//
//   GuideCardData.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions

struct GuideCardData: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let linkText: String
    let linkURL: String
}
