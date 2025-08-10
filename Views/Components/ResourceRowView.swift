//
//  ResourceRowView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 16/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
<<<<<<< HEAD
import SwiftUICore
=======
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf

struct ResourceRowView: View {
    let resource: HelpResource // It was (let resource: UserResource) changed to (let resource: HelpResource)
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")



    var body: some View {
        HStack(spacing: 16) {
            categoryIcon

            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top) {
                    Text(resource.title)
                        .font(.headline)
                        .lineLimit(2)

                    Spacer()

                    if resource.isCritical {
                        Text("URGENT")
                            .font(.caption2)
                            .bold()
                            .padding(4)
                            .background(Color.red.opacity(0.2))
                            .foregroundColor(.red)
                            .cornerRadius(4)
                    }
                }

                Text(resource.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            if resource.type == .inApp || resource.urlString != nil {
                Image(systemName: "chevron.right")
                    .foregroundColor(AppColors.textSecondary)

            }
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityHint(resource.accessibilityHint ?? "")
    }

    private var categoryIcon: some View {
        ZStack {
            Circle()
                .fill(Color.accentColor.opacity(0.1))
                .frame(width: 40, height: 40)

            Image(systemName: resource.iconName)
                .foregroundColor(.accentColor)
                .font(.system(size: 18))
        }
    }
}
