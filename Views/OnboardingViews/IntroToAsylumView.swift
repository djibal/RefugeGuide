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

                Text("If you're planning to seek asylum, this guide will help you understand each step of the journey.")
                    .font(.body)

                VStack(alignment: .leading, spacing: 12) {
                    Text("🔹 **Step 1: Screening Interview**\nYour first contact with the Home Office. Basic questions and biometric data are collected.")
                    Text("🔹 **Step 2: Substantive Interview**\nA detailed interview about why you're seeking asylum.")
                    Text("🔹 **Step 3: Decision**\nYou receive a decision. If denied, you may have the right to appeal.")
                    Text("🔹 **Step 4: Outcome & Support**\nIf granted, you’ll transition to residence. If refused, support is still available.")
                }
                .font(.body)

                Divider()

                Text("🛠️ With RefugeGuide, you can:")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 10) {
                    Text("• Track your application progress")
                    Text("• Upload and store key documents")
                    Text("• Get help via our multilingual assistant")
                    Text("• Access local support services")
                }

                Spacer()

                Button(action: onContinue) {
                    Text("Register to Begin")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle("Asylum Guide")
    }
}
