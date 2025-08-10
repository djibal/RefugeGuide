//
//  LanguageSelectedView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 14/07/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions
<<<<<<< HEAD
import SwiftUICore
=======
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf

struct LanguageSelectedView: View {
    
    @Binding var selectedLanguage: String
    var onContinue: () -> Void
    
<<<<<<< HEAD
    
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

    
=======
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
    var body: some View {
        TopAlignedScrollView {
            TopAlignedScrollView {
                VStack(spacing: 30) {
                    Text("Select your preferred language")
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)
                        .lineLimit(nil) // Replace lineLimit(2) with nil
                        .minimumScaleFactor(0.5)
                        .padding()
                    
                    VStack(spacing: 20) {
                        LanguageButton(language: "English", code: "en", isSelected: selectedLanguage == "en") {
                            selectedLanguage = "en"
                        }
                        
                        LanguageButton(language: "العربية (Arabic)", code: "ar", isSelected: selectedLanguage == "ar") {
                            selectedLanguage = "ar"
                        }
                        
                        LanguageButton(language: "Français (French)", code: "fr", isSelected: selectedLanguage == "fr") {
                            selectedLanguage = "fr"
                        }
                        
                        LanguageButton(language: "فارسی (Farsi)", code: "fa", isSelected: selectedLanguage == "fa") {
                            selectedLanguage = "fa"
                        }
                        
                        LanguageButton(language: "کوردی (Kurdish)", code: "ku", isSelected: selectedLanguage == "ku") {
                            selectedLanguage = "ku"
                        }
                        
                        LanguageButton(language: "پښتو (Pashto)", code: "ps", isSelected: selectedLanguage == "ps") {
                            selectedLanguage = "ps"
                        }
                        
                        LanguageButton(language: "Українська (Ukrainian)", code: "uk", isSelected: selectedLanguage == "uk") {
                            selectedLanguage = "uk"
                        }
                        
                        LanguageButton(language: "اردو (Urdu)", code: "ur", isSelected: selectedLanguage == "ur") {
                            selectedLanguage = "ur"
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button(action: onContinue) {
                        Text("Continue")
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
<<<<<<< HEAD
                            .background(AppColors.primary)
=======
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

struct LanguageButton: View {
    let language: String
    let code: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(language)
                    .font(.title2)
                    .foregroundColor(.primary)
                    .lineLimit(nil) // Ensure full text display
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
    }
}
