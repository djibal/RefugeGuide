//
//  DocumentAIResult.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 30/06/2025.
//

import Foundation

/// Stores the result of AI-powered document analysis
struct DocumentAIResult {
    let type: UKDocumentType
    let validationStatus: ValidationStatus
    let expiryDate: Date?
    let issues: [String]
    let suggestions: [String]

    /// Possible validation outcomes after AI analysis
    enum ValidationStatus: String {
        case valid
        case expired
        case suspicious
        case invalid
        case needsReview
    }
}

