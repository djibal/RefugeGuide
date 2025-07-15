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

        docAnalyzer.analyzeDocument(at: url, type: type) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let documentResult):
                    self?.state = .result(documentResult)
                case .failure(let error):
                    self?.state = .error("Failed to process document: \(error.localizedDescription)")
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

        docAnalyzer.analyzeImage(image, type: type) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageResult):
                    self?.state = .result(imageResult)
                case .failure(let error):
                    self?.state = .error("Failed to process image: \(error.localizedDescription)")
                }
            }
        }
    }
}
