//
//  ExistingAsylumVerificationView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
//


import SwiftUI

struct ExistingAsylumVerificationView: View {
    @State private var referenceNumber = ""
    @State private var isVerified = false
    @State private var showError = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("""
                Enter your Home Office reference number (UAN), which looks like:
                1234-5678-9012-3456

                This is different from your NASS reference number.
                """)
                .font(.body)
                .multilineTextAlignment(.center)

                Text("Enter your Home Office reference number (UAN)")
                    .font(.body)
                    .multilineTextAlignment(.center)

                TextField("e.g. 1234-5678-9012-3456", text: $referenceNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.asciiCapable)
                    .autocapitalization(.allCharacters)
                    .padding(.horizontal)

                Button("Verify") {
                    verifyReference()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)

                if showError {
                    Text("❌ We couldn’t verify that number. Please check it and try again.")
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Text("Need help? Contact the Home Office Helpline or your caseworker.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                if isVerified {
                    NavigationLink(destination: EVisaView()) {
                        Text("View eVisa")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }

                Spacer()

                Text("""
                🔒 Your Unique Application Number (UAN) is encrypted during verification.

                You can usually find it on:
                - Your Home Office application confirmation email
                - Your ARC (Asylum Registration Card)

                ❌ Do not enter your NASS reference number here — it’s used for support services only.
                """)
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            }
            .padding()
        }
        .navigationTitle("Reference Verification")
    }

    func verifyReference() {
        // Simulated match for testing — use exact format
        if referenceNumber.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() == "1234-5678-9012-3456" {
            isVerified = true
            showError = false
        } else {
            showError = true
            isVerified = false
        }
    }
}

#Preview {
    ExistingAsylumVerificationView()
}
