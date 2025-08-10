//
//  LanguagePickerView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 05/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct LanguagePickerView: View {
    @AppStorage("selectedLanguage") var selectedLanguage: String = "en"
    var onContinue: () -> Void
    
    // MARK: - UI Constants
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

    let languages = [
        ("English", "en"),
        ("Arabic", "ar"),
        ("Farsi", "fa"),
        ("French", "fr"),
        ("Ukrainian", "uk"),
        ("Urdu", "ur"),
        ("Pashto", "ps"),
        ("Kurdish", "ku")
    ]

    var body: some View {
        TopAlignedScrollView { // Replace ScrollView by TopAlignedScrollView
            TopAlignedScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 10) {
                        Image(systemName: "globe")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(primaryColor)
                        
                        Text("Select your preferred language")
                            .font(.title2.bold())
                            .multilineTextAlignment(.center)
                            .foregroundColor(primaryColor)
                            .lineLimit(nil) // Ensure full text display
                    }
                    .padding(.top, 20)

                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(languages, id: \.1) { lang in
                            Text(lang.0).tag(lang.1)
                                .foregroundColor(primaryColor)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 150)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)

                    Button(action: onContinue) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .background(AppColors.primary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(primaryColor)
                            .cornerRadius(12)
                            .padding(.horizontal, 40)
                            .shadow(color: primaryColor.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .padding(.top, 20)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .id("top") // Identifier for scrolling
            }
            .background(backgroundColor.ignoresSafeArea())
        }
    }
}
