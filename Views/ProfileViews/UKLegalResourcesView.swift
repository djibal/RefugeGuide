//
//  UKLegalResourcesView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//

import SwiftUI

struct UKLegalResourcesView: View {
    var body: some View {
        List {
            Section(header: Text("Legal Aid Services")) {
                ResourceLink(
                    title: "Citizens Advice",
                    subtitle: "Free legal advice and housing support.",
                    url: "https://www.citizensadvice.org.uk"
                )

                ResourceLink(
                    title: "Refugee Council",
                    subtitle: "Specialized help for asylum seekers and refugees.",
                    url: "https://www.refugeecouncil.org.uk"
                )

                ResourceLink(
                    title: "Right to Remain",
                    subtitle: "UK immigration and asylum support resources.",
                    url: "https://righttoremain.org.uk"
                )
            }

            Section(header: Text("Legal Helplines")) {
                ResourceLink(
                    title: "Migrant Help (24/7)",
                    subtitle: "0808 8010 503",
                    url: "tel://08088010503"
                )

                ResourceLink(
                    title: "LawWorks (Pro Bono)",
                    subtitle: "Free legal help for individuals in need.",
                    url: "https://www.lawworks.org.uk"
                )
            }
        }
        .navigationTitle("Legal Help Resources")
    }
}

struct ResourceLink: View {
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
