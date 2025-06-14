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
                Text("Verify Your Home Office Reference Number")
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)

                Text("""
                If you’re an existing asylum seeker, we can help you manage your case, upload documents, and track your application.

                Please enter your **Home Office UAN (Unique Application Number)** below:
                """)
                .font(.body)

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

                Button("Skip and Continue to Registration") {
                    // Optional path if user wants to continue without UAN
                }
                .foregroundColor(.blue)
                .padding(.top)

                Divider()

                Text("""
                🔒 Your UAN is encrypted during verification.

                You can find it on:
                • Home Office confirmation email  
                • ARC (Asylum Registration Card)

                ⚠️ Do not enter your NASS number — that’s for support services only.
                """)
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("Reference Verification")
    }

    func verifyReference() {
        if referenceNumber.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() == "1234-5678-9012-3456" {
            isVerified = true
            showError = false
        } else {
            showError = true
            isVerified = false
        }
    }
}
