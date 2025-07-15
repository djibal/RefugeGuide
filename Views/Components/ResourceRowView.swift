//
//  ResourceRowView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 16/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions

struct ResourceRowView: View {
    let resource: HelpResource // It was (let resource: UserResource) changed to (let resource: HelpResource)


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
                    .foregroundColor(.gray)
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
