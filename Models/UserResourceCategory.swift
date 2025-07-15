//
//  UserResourceCategory.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/07/2025.

import Foundation
import SwiftUI
import FirebaseFunctions

enum UserResourceCategory: String, CaseIterable, Identifiable, Codable {
    case mentalHealth = "Mental Health"
    case safety = "Safety"
    case community = "Community"
    case generalSupport = "General Support"
    case housing = "Housing"
    case legal = "Legal Aid"
    
    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .mentalHealth: return "Mental Health"
        case .safety: return "Safety Planning"
        case .community: return "Community Resources"
        case .generalSupport: return "General Support"
        case .housing: return "Housing"
        case .legal: return "Legal Aid"
        }
    }

    var iconName: String {
        switch self {
        case .mentalHealth: return "brain.head.profile"
        case .safety: return "shield.lefthalf.fill"
        case .community: return "map"
        case .generalSupport: return "questionmark.circle"
        case .housing: return "house"
        case .legal: return "gavel"
        }
    }

    // ✅ NEW: lets SwiftUI access systemIcon without renaming iconName elsewhere
    var systemIcon: String {
        return iconName
    }
}
