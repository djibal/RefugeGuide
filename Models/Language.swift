//
//  Language.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 11/07/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions
<<<<<<< HEAD
import SwiftUICore

enum Language: String, CaseIterable, Identifiable {
    
=======

enum Language: String, CaseIterable, Identifiable {
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
    case english = "en"
    case arabic = "ar"
    case urdu = "ur"
    case farsi = "fa"
    case french = "fr"
    case ukrainian = "uk"
    case pashto = "ps"
    case kurdish = "ku"
<<<<<<< HEAD
    
=======
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf

    var id: String { rawValue }

    var displayName: String {
<<<<<<< HEAD
        
        
=======
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
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
