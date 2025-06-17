//
//  ResourceRowView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 16/06/2025.
//

import SwiftUI

struct ResourceRowView: View {
    let resource: HelpResource

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: resource.iconName)
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(resource.title)
                    .font(.headline)
                Text(resource.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if resource.type == .inApp {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityHint(resource.type == .inApp ? "Opens in app" : "Opens external link")
    }
}
