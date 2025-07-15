//
//  UKDocumentType.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 30/06/2025.
//


import Foundation
import SwiftUI
import FirebaseFunctions

/// Enum representing supported UK document types for AI analysis
enum UKDocumentType: String, CaseIterable, Identifiable {
    case passport = "Passport"
    case birthCertificate = "Birth Certificate"
    case proofOfAddress = "Proof of Address"
    case nassCard = "NASS Card"
    case biometricResidence = "Biometric Residence"
    case asylumApplication = "Asylum Application"
    case other = "Other Document"

    var id: String { rawValue }

    /// Returns an SF Symbol name appropriate for the document type.
    var iconName: String {
        switch self {
        case .passport: return "globe.europe.africa"
        case .birthCertificate: return "doc.text"
        case .proofOfAddress: return "house"
        case .nassCard: return "creditcard"
        case .biometricResidence: return "person.badge.key"
        case .asylumApplication: return "doc.plaintext"
        case .other: return "doc"
        }
    }
}
