//
//  AsylumReferenceVerificationView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 17/07/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct AsylumReferenceVerificationView: View {
    @State private var uanNumber: String = ""
    @State private var isVerifying = false
    @FocusState private var isTextFieldFocused: Bool
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")


    
    var onContinue: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Text("Verify Your Asylum Reference")
                .font(.title2)
                .bold()
                .foregroundColor(primaryColor)

            Text("Please enter your Unique Application Number (UAN) to verify your status.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            TextField("Enter your UAN", text: $uanNumber)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .focused($isTextFieldFocused)

            Button(action: {
                isVerifying = true
                // Future: Add backend call if needed
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    isVerifying = false
                    onContinue()
                }
            }) {
                Text("Verify")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(uanNumber.isEmpty ? Color.gray.opacity(0.4) : primaryColor)
                    .foregroundColor(.white)
                    .background(AppColors.primary)
                    .cornerRadius(10)
            }
            .disabled(uanNumber.isEmpty || isVerifying)

            VStack(alignment: .leading, spacing: 8) {
                Label("What is a UAN?", systemImage: "questionmark.circle.fill")
                    .foregroundColor(.orange)
                    .font(.headline)

                Text("Your Unique Application Number (UAN) is provided by the UK Home Office in asylum correspondence.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            Spacer()

            Button("Skip for now") {
                onContinue()
            }
            .foregroundColor(primaryColor)
        }
        .padding()
        .background(Color(red: 0.96, green: 0.96, blue: 0.98).ignoresSafeArea())
    }
}
