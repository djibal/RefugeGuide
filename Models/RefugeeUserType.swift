//
//  RefugeeUserType.swift
//  RefugeGuide
//
////  Created by Djibal Ramazani on 02/07/2025.
////
//
import Foundation
import SwiftUI

enum RefugeeUserType: String, Codable, CaseIterable {
    case unknown
    case refugee
    case asylumSeeker
    case newAsylumSeeker
    case seekingAsylum
    case existingAsylumSeeker
    case residencePermitHolder
    case grantedResidence
}

// MARK: - Computed Display Names
extension RefugeeUserType {
    
    /// Default display name in English
    var displayName: String {
        switch self {
        case .refugee: return "Refugee"
        case .asylumSeeker: return "Asylum Seeker"
        case .newAsylumSeeker: return "New Asylum Seeker"
        case .seekingAsylum: return "Seeking Asylum"
        case .existingAsylumSeeker: return "Existing Asylum Seeker"
        case .residencePermitHolder: return "Residence Permit Holder"
        case .grantedResidence: return "Granted Residence"
        case .unknown: return "Not Sure"
        }
    }
    
    /// Multilingual display name
    func displayName(for lang: String) -> String {
        switch (self, lang) {
        case (.refugee, "ar"): return "لاجئ"
        case (.refugee, "fr"): return "Réfugié"
        case (.refugee, "fa"): return "پناهنده"
        case (.refugee, "ur"): return "پناہ گزین"
        case (.refugee, "ps"): return "کډوال"
        case (.refugee, "uk"): return "Біженець"
        case (.refugee, "ku"): return "Penaber"
        case (.asylumSeeker, "ar"): return "طالب لجوء"
        case (.asylumSeeker, "fr"): return "Demandeur d’asile"
        case (.asylumSeeker, "fa"): return "درخواست‌دهنده پناهندگی"
        case (.asylumSeeker, "ur"): return "پناہ کے متلاشی"
        case (.asylumSeeker, "ps"): return "د پناه غوښتنې غوښتونکی"
        case (.asylumSeeker, "uk"): return "Шукач притулку"
        case (.asylumSeeker, "ku"): return "Xwestekarê penaberiyê"
        case (.unknown, _): return "Not Sure"
        default:
            return self.displayName // fallback to English
        }
    }
}

// MARK: - Onboarding Options
extension RefugeeUserType {
    static var primaryOptions: [RefugeeUserType] {
        return [.asylumSeeker, .existingAsylumSeeker, .refugee]
    }
}
