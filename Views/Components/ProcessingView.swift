//
//  ProcessingView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 30/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct ProcessingView: View {
    let progress: Double
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

    var body: some View {
        VStack(spacing: 20) {
            ProgressView(value: progress, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle())
                .frame(width: 200)

            Text("Analyzing Document...")
                .font(.headline)

            Text("\(Int(progress * 100))% complete")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
