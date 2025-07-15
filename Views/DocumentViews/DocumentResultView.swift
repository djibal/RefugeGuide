//
//  DocumentResultView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 30/06/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct DocumentResultView: View {
    let result: DocumentAIResult
    let onRetry: () -> Void
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Document Analysis Result")
                    .font(.title2)
                    .padding(.bottom)

                InfoRow(title: "Document Type", value: result.type.rawValue)
                InfoRow(title: "Validity Status", value: result.validationStatus.rawValue)
                InfoRow(title: "Expiry Date", value: result.expiryDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")

                if !result.issues.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Potential Issues:")
                            .font(.headline)
                        ForEach(result.issues, id: \.self) {
                            Text("• \($0)")
                        }
                    }
                }

                if !result.suggestions.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Recommendations:")
                            .font(.headline)
                        ForEach(result.suggestions, id: \.self) {
                            Text("• \($0)")
                        }
                    }
                }

                Button("Scan Another", action: onRetry)
                    .buttonStyle(PrimaryButtonStyle(backgroundColor: Color(red: 0.07, green: 0.36, blue: 0.65))) // Deep UK blue
                    .padding(.top)
            }
            .padding()
        }
    }

    private struct InfoRow: View {
        let title: String
        let value: String

        var body: some View {
            HStack {
                Text(title)
                    .fontWeight(.medium)
                Spacer()
                Text(value)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
    }
}
