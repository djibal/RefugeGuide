//
//  GuideContentView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//

import SwiftUI

struct GuideContentView: View {
    let selectedLanguage: String
    let title: String
    let subtitle: String
    let cards: [GuideCardData]
    let continueButtonText: String
    let onContinue: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .padding(.bottom)

            Text(subtitle)
                .font(.title2)
                .padding(.bottom)

            ForEach(cards) { card in
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: card.icon)
                        Text(card.title)
                            .font(.headline)
                    }
                    Text(card.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Link(card.linkText, destination: URL(string: card.linkURL)!)
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            }

            Spacer()

            Button(continueButtonText, action: onContinue)
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
        }
        .padding()
    }
}
