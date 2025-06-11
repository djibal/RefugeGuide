//
//  IntroToAsylumView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 05/06/2025.
//
import SwiftUI

struct IntroToAsylumView: View {
    var onContinue: () -> Void = {}

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Welcome to the UK Asylum Process")
                    .font(.title2)
                    .bold()

                Text("Here’s what you’ll go through as part of your asylum application:")
                    .font(.body)

                // Sample steps – you can replace this with your styled info cards
                Text("1. Screening Interview")
                Text("2. Substantive Interview")
                Text("3. Receive Decision")
                Text("4. Appeal (if needed)")

                Spacer()

                Button("Continue") {
                    onContinue()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Asylum Guide")
    }
}
