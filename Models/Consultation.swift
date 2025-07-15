//
//  Consultation.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 15/06/2025.
//

// Consultation.swift

import Foundation
import SwiftUI
import FirebaseFunctions
import FirebaseFirestoreSwift

struct Consultation: Identifiable, Codable {
    @DocumentID var id: String?
    let date: Date
    let type: ConsultationType
    var status: ConsultationStatus
    var specialistID: String?
    var notes: String?
    @ServerTimestamp var createdAt: Date?
}


enum ConsultationType: String, Codable, CaseIterable {
    case legal, medical, housing, psychological
    
    var displayName: String {
        switch self {
        case .legal: return "Legal Advice"
        case .medical: return "Medical Consultation"
        case .housing: return "Housing Support"
        case .psychological: return "Psychological Support"
        }
    }
}

enum ConsultationStatus: String, Codable {
    case scheduled, completed, cancelled, inProgress
    
    var color: String {
        switch self {
        case .scheduled: return "blue"
        case .inProgress: return "orange"
        case .completed: return "green"
        case .cancelled: return "red"
        }
    }
}
