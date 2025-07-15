//
//  AppColors.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 20/07/2025.
//

import SwiftUI

import SwiftUI

struct AppColors {
    static let primary = Color(hex: "#0D3B66")
    static let accent = Color(hex: "#F95738")
    static let background = Color(hex: "#F5F9FF")
    static let card = Color(hex: "#FFFFFF")
    static let textPrimary = Color(hex: "#1A1A1A")
    static let textSecondary = Color(hex: "#555555")
    static let secondary = Color.gray   
    static let cardBackground = Color.white
    }


// HEX initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}
