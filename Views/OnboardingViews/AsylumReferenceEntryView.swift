//
//  AsylumReferenceEntryView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 17/07/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore


struct AsylumReferenceEntryView: View {
    let userType: RefugeeUserType
    var onContinue: () -> Void
    
    @State private var referenceNumber: String = ""
    @State private var isVerifying = false
    @FocusState private var focused: Bool
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

    var body: some View {
        VStack(spacing: 24) {
            Text(referenceTitle)
                .font(.title2)
                .bold()
                .foregroundColor(primaryColor)

            Text(referenceDescription)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            TextField("Enter reference number", text: $referenceNumber)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .focused($focused)

            Button(action: verifyAndContinue) {
                Text("Verify")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(referenceNumber.isEmpty ? Color.gray.opacity(0.4) : primaryColor)
                    .foregroundColor(.white)
                    .background(AppColors.primary)
                    .cornerRadius(10)
            }
            .disabled(referenceNumber.isEmpty || isVerifying)

            VStack(alignment: .leading, spacing: 8) {
                Label(helpTitle, systemImage: "questionmark.circle.fill")
                    .foregroundColor(.orange)
                    .font(.headline)

                Text(helpDescription)
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
        .onAppear { focused = true }
    }

    // MARK: - Dynamic Content

    private var referenceTitle: String {
        switch userType {
        case .asylumSeeker, .newAsylumSeeker, .seekingAsylum:
            return "Verify Your Home Office Reference"
        case .existingAsylumSeeker:
            return "Verify Your UAN"
        case .grantedResidence, .refugee, .residencePermitHolder:
            return "Enter Your UAN or Reference"
        default:
            return "Verify Your Reference"
        }
    }

    private var referenceDescription: String {
        switch userType {
        case .asylumSeeker, .newAsylumSeeker, .seekingAsylum:
            return "Please enter the reference number you received when starting your asylum application."
        case .existingAsylumSeeker:
            return "Please enter your Unique Application Number (UAN) as provided by the UK Home Office."
        case .grantedResidence, .refugee, .residencePermitHolder:
            return "Enter the UAN or reference number found in your residence approval documents."
        default:
            return "Enter any official reference you have received."
        }
    }

    private var helpTitle: String {
        switch userType {
        case .existingAsylumSeeker:
            return "What is a UAN?"
        default:
            return "Where to find your reference?"
        }
    }

    private var helpDescription: String {
        switch userType {
        case .existingAsylumSeeker:
            return "Your Unique Application Number (UAN) is provided by the UK Home Office in official correspondence."
        case .asylumSeeker, .newAsylumSeeker, .seekingAsylum:
            return "This number is provided to you when you begin your asylum claim."
        default:
            return "Look for your UAN or Home Office Reference in official letters or decision emails."
        }
    }

    private func verifyAndContinue() {
        isVerifying = true
        // Future: Validate reference against backend
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isVerifying = false
            onContinue()
        }
    }
}
