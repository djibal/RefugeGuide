//
//  DocumentAIViewModel.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 29/06/2025.
//

import Foundation
import SwiftUI
import Vision
import UIKit


class DocumentAIViewModel: ObservableObject {
    enum State {
        case idle
        case processing(progress: Double)
        case result(DocumentAIResult)
        case error(String)
    }

    @Published var state: State = .idle
    @Published var selectedType: UKDocumentType?

    private let docAnalyzer = DocumentAnalyzer()

    var progress: Double {
        if case .processing(let value) = state {
            return value
        } else {
            return 0
        }
    }

    func reset() {
        state = .idle
        selectedType = nil
    }

    func processDocument(url: URL) {
        guard let type = selectedType else {
            state = .error("Please select a document type.")
            return
        }

        state = .processing(progress: 0)

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                let result = try self?.docAnalyzer.analyzeDocument(at: url, type: type)
                DispatchQueue.main.async {
                    if let result = result {
                        self?.state = .result(result)
                    } else {
                        self?.state = .error("Failed to process document.")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self?.state = .error(error.localizedDescription)
                }
            }
        }
    }

    func processImage(_ image: UIImage) {
        guard let type = selectedType else {
            state = .error("Please select a document type.")
            return
        }

        state = .processing(progress: 0)

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                let result = try self?.docAnalyzer.analyzeImage(image, type: type)
                DispatchQueue.main.async {
                    if let result = result {
                        self?.state = .result(result)
                    } else {
                        self?.state = .error("Failed to process image.")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self?.state = .error(error.localizedDescription)
                }
            }
        }
    }
}
