//
//  Consultation.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 15/06/2025.
//

import Foundation
import FirebaseFunctions
import FirebaseAuth
import SwiftUI
import FirebaseFirestoreSwift

/// Represents a scheduled or past consultation in the RefugeGuide app.
struct Consultation: Identifiable, Codable, Hashable {
    /// Firestore document ID for the consultation.
    @DocumentID var id: String?
    
    /// The scheduled date & time for the consultation.
    let date: Date
    
    /// The type of consultation (legal, medical, etc.).
    let type: ConsultationType
    
    /// The current status of the consultation.
    var status: ConsultationStatus
    
    /// Optional ID of the specialist handling the consultation.
    var specialistID: String?
    
    /// Optional notes or description for the consultation.
    var notes: String?
    
    /// Date when the consultation document was created in Firestore.
    @ServerTimestamp var createdAt: Date?
    
    // MARK: - Hashable & Equatable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id ?? "")
    }
    
    static func == (lhs: Consultation, rhs: Consultation) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Consultation Types

enum ConsultationType: String, Codable, CaseIterable, Hashable {
    case legal
    case medical
    case housing
    case psychological

    var displayName: String {
        switch self {
        case .legal: return "Legal Advice"
        case .medical: return "Medical Consultation"
        case .housing: return "Housing Support"
        case .psychological: return "Psychological Support"
        }
    }
}

// MARK: - Consultation Status

enum ConsultationStatus: String, Codable, Hashable {
    case scheduled
    case completed
    case cancelled
    case inProgress

    var displayName: String {
        switch self {
        case .scheduled: return "Scheduled"
        case .completed: return "Completed"
        case .cancelled: return "Cancelled"
        case .inProgress: return "In Progress"
        }
    }
}
