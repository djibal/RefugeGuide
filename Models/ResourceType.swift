//
//  ResourceType.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 05/07/2025.
//
// ResourceType.swift

import Foundation
import SwiftUI

enum ResourceType: String, Codable {
    case phone
    case web
    case email
    case inApp
    case external    // ✅ Add this missing case

    var displayName: String {
        switch self {
        case .phone: return "Phone"
        case .web: return "Website"
        case .email: return "Email"
        case .inApp: return "In-App"
        case .external: return "External Link" // ✅ Add display name too
        }
    }
}
