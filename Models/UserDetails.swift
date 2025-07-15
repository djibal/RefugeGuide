//
//  UserDetails.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 15/07/2025.
//

import Foundation
import SwiftUI

struct UserDetails: Codable, Identifiable {
    var id: String { caseReference ?? UUID().uuidString }
    
    var caseReference: String?
    var legalStatus: UKLegalStatus
    var arrivalDate: Date?
    var nationality: String?
    var language: String?
    
    
    enum CodingKeys: String, CodingKey {
        case caseReference = "case_reference"
        case legalStatus = "legal_status"
        case arrivalDate = "arrival_date"
        case nationality, language
    }
}

enum UKLegalStatus: String, Codable {
    case asylumSeeker = "asylum_seeker"
    case refugee = "refugee"
    case humanitarianProtection = "humanitarian_protection"
    case discretionaryLeave = "discretionary_leave"
    case undocumented = "undocumented"
    
    var displayName: String {
        switch self {
        case .asylumSeeker: return "Asylum Seeker"
        case .refugee: return "Refugee"
        case .humanitarianProtection: return "Humanitarian Protection"
        case .discretionaryLeave: return "Discretionary Leave"
        case .undocumented: return "Undocumented"
        }
    }
    
    var color: Color {
        switch self {
        case .refugee: return .green
        case .asylumSeeker: return .orange
        case .humanitarianProtection: return .blue
        case .discretionaryLeave: return .purple
        case .undocumented: return .red
        }
    }
}


