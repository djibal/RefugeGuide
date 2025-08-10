//
//  Language.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 11/07/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore


enum Language: String, CaseIterable, Identifiable {

    case english = "en"
    case arabic = "ar"
    case urdu = "ur"
    case farsi = "fa"
    case french = "fr"
    case ukrainian = "uk"
    case pashto = "ps"
    case kurdish = "ku"

    var id: String { rawValue }

    var displayName: String {
        
        switch self {
        case .english: return "English"
        case .arabic: return "العربية"
        case .urdu: return "اردو"
        case .farsi: return "فارسی"
        case .french: return "Français"
        case .ukrainian: return "Українська"
        case .pashto: return "پښتو"
        case .kurdish: return "Kurdî"
        }
    }
}
