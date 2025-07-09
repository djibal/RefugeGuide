//
//  LanguageAssistanceView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//

import SwiftUI

struct LanguageAssistanceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Your Right to Language Assistance")
                    .font(.title2.bold())

                Text("You are entitled to free interpretation and translation support when dealing with UK immigration, healthcare, and legal systems.")

                Divider()

                Text("How to Request Help")
                    .font(.headline)

                Text("Let the staff know your preferred language. They must provide a qualified interpreter, especially during Home Office interviews and medical appointments.")

                Divider()

                Text("Recommended Services")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 12) {
                    ResourceLink(
                        title: "Clear Voice Interpreting",
                        subtitle: "Free multilingual support for refugees.",
                        url: "https://clearvoice.org.uk"
                    )

                    ResourceLink(
                        title: "Migrant Help Translation",
                        subtitle: "24/7 support including language access.",
                        url: "https://www.migranthelpuk.org"
                    )

                    ResourceLink(
                        title: "Big Word Services",
                        subtitle: "Government-authorized interpreters.",
                        url: "https://thebigword.com"
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Language Support")
    }
}

struct UserResourceLink: View {
    let title: String
    let subtitle: String
    let url: String

    var body: some View {
        Link(destination: URL(string: url)!) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 6)
        }
    }
}
