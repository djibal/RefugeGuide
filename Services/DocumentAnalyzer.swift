//
//  DocumentAnalyzer.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 30/06/2025.
//

import Foundation
import FirebaseFunctions
import Vision
import UIKit

final class DocumentAnalyzer {
    private lazy var functions = Functions.functions()

    // ✅ Keeps your original sync signature working by bridging to the async/closure flow.
    //    (Blocks the calling thread; ok for quick compatibility. Prefer the completion API below.)
    func analyzeDocument(at url: URL, type: UKDocumentType) throws -> DocumentAIResult {
        var output: Result<DocumentAIResult, Error>?
        let sema = DispatchSemaphore(value: 0)

        analyzeDocument(at: url, type: type) { result in
            output = result
            sema.signal()
        }

        // Optional timeout to avoid hanging forever.
        _ = sema.wait(timeout: .now() + 30)

        guard let resolved = output else {
            throw NSError(domain: "DocumentAnalyzer",
                          code: 408,
                          userInfo: [NSLocalizedDescriptionKey: "Analysis timed out."])
        }
        switch resolved {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }

    // ✅ Preferred completion-based API
    func analyzeDocument(at url: URL, type: UKDocumentType,
                         completion: @escaping (Result<DocumentAIResult, Error>) -> Void) {
        guard let image = UIImage(contentsOfFile: url.path) else {
            completion(.failure(NSError(domain: "DocumentAnalyzer", code: 1,
                                        userInfo: [NSLocalizedDescriptionKey: "Failed to load image from URL."])))
            return
        }
        analyzeImage(image, type: type, completion: completion)
    }

    func analyzeImage(_ image: UIImage, type: UKDocumentType,
                      completion: @escaping (Result<DocumentAIResult, Error>) -> Void) {
        recognizeText(in: image) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let text):
                self.callCloudFunction(with: text, type: type, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - OCR

    private func recognizeText(in image: UIImage,
                               completion: @escaping (Result<String, Error>) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(.failure(NSError(domain: "DocumentAnalyzer", code: 2,
                                        userInfo: [NSLocalizedDescriptionKey: "Failed to create CGImage."])))
            return
        }

        let handler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let observations = (request.results as? [VNRecognizedTextObservation]) ?? []
            let recognized = observations.compactMap { $0.topCandidates(1).first?.string }
            completion(.success(recognized.joined(separator: "\n")))
        }

        do {
            try handler.perform([request])
        } catch {
            completion(.failure(error))
        }
    }

    // MARK: - Cloud Function

    private func callCloudFunction(with text: String, type: UKDocumentType,
                                   completion: @escaping (Result<DocumentAIResult, Error>) -> Void) {
        functions.httpsCallable("analyzeDocument").call([
            "text": text,
            "type": type.rawValue
        ]) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = result?.data as? [String: Any],
                  let statusRaw = data["validationStatus"] as? String,
                  let status = DocumentAIResult.ValidationStatus(rawValue: statusRaw)
            else {
                completion(.failure(NSError(domain: "DocumentAnalyzer", code: 3,
                                            userInfo: [NSLocalizedDescriptionKey: "Invalid response from cloud function."])))
                return
            }

            let expirySeconds = data["expiryDate"] as? Double
            let expiryDate = expirySeconds.map { Date(timeIntervalSince1970: $0) }
            let issues = data["issues"] as? [String] ?? []
            let suggestions = data["suggestions"] as? [String] ?? []

            let doc = DocumentAIResult(
                type: type,
                validationStatus: status,
                expiryDate: expiryDate,
                issues: issues,
                suggestions: suggestions
            )
            completion(.success(doc))
        }
    }
}
