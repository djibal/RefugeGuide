//
//  PathOptionCard.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 11/07/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct PathOptionCard: View {
    let title: String
    let description: String
    let color: Color
    let iconName: String?
    let spacing: CGFloat
  

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            HStack(spacing: 8) {
                if let icon = iconName {
                    Image(systemName: icon)
                        .foregroundColor(color)
                }
                Text(title)
                    .font(.headline)
                    .foregroundColor(color)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color, lineWidth: 1)
        )
    }
}
