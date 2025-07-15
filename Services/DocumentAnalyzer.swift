//
//  DocumentAnalyzer.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 30/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import Vision
import UIKit


class DocumentAnalyzer {
    private lazy var functions = Functions.functions()

    func analyzeDocument(at url: URL, type: UKDocumentType, completion: @escaping (Result<DocumentAIResult, Error>) -> Void) {
        guard let image = UIImage(contentsOfFile: url.path) else {
            completion(.failure(NSError(domain: "DocumentAnalyzer", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to load image from URL."])))
            return
        }
        recognizeText(in: image) { result in
            switch result {
            case .success(let text):
                self.callCloudFunction(with: text, type: type, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func analyzeImage(_ image: UIImage, type: UKDocumentType, completion: @escaping (Result<DocumentAIResult, Error>) -> Void) {
        recognizeText(in: image) { result in
            switch result {
            case .success(let text):
                self.callCloudFunction(with: text, type: type, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func recognizeText(in image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(.failure(NSError(domain: "DocumentAnalyzer", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to create CGImage."])))
            return
        }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(.success(""))
                return
            }

            let recognizedStrings = observations.compactMap { observation in
                return observation.topCandidates(1).first?.string
            }

            completion(.success(recognizedStrings.joined(separator: "\n")))
        }

        do {
            try requestHandler.perform([request])
        } catch {
            completion(.failure(error))
        }
    }

    private func callCloudFunction(with text: String, type: UKDocumentType, completion: @escaping (Result<DocumentAIResult, Error>) -> Void) {
        functions.httpsCallable("analyzeDocument").call(["text": text, "type": type.rawValue]) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = result?.data as? [String: Any],
            let validationStatusRaw = data["validationStatus"] as? String,
            let validationStatus = DocumentAIResult.ValidationStatus(rawValue: validationStatusRaw) else {
                completion(.failure(NSError(domain: "DocumentAnalyzer", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid response from cloud function."])))
                return
            }

            let expiryDateTimestamp = data["expiryDate"] as? Double
            let expiryDate = expiryDateTimestamp != nil ? Date(timeIntervalSince1970: expiryDateTimestamp!) : nil
            let issues = data["issues"] as? [String] ?? []
            let suggestions = data["suggestions"] as? [String] ?? []

            let documentResult = DocumentAIResult(
                type: type,
                validationStatus: validationStatus,
                expiryDate: expiryDate,
                issues: issues,
                suggestions: suggestions
            )

            completion(.success(documentResult))
        }
    }
}
