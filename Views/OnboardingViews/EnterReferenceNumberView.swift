//
//  EnterReferenceNumberView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 19/07/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct EnterReferenceNumberView: View {
    
    let title: String
    let subtitle: String
    let placeholder: String
    let onComplete: (_ refNumber: String?) -> Void
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")


    @State private var referenceNumber: String = ""
    @FocusState private var isInputFocused: Bool
    @AppStorage("userRefNumber") private var storedRefNumber: String = ""


    var body: some View {
        VStack(spacing: 24) {
            Text(title)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top, 40)
                .foregroundColor(primaryColor)

            Text(subtitle)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            TextField(placeholder, text: $referenceNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .focused($isInputFocused)
                .submitLabel(.done)

            VStack(spacing: 12) {
                Button(action: {
                    storedRefNumber = referenceNumber
                    onComplete(referenceNumber)
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(AppColors.primary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(primaryColor)
                        .cornerRadius(12)
                }
                .disabled(referenceNumber.isEmpty)

                Button("Skip for now") {
                    onComplete(nil)
                }
                .foregroundColor(AppColors.textSecondary)

                .padding(.top, 4)
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding()
        .background(backgroundColor.ignoresSafeArea())
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isInputFocused = true
            }
        }
    }
}
