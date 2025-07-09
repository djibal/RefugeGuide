//
//  LanguageSelectionView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 29/06/2025.
//

import SwiftUI

struct LanguageSelectionView: View {
    @Binding var selectedLanguage: String?
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @State private var navigateToNext = false
       var onContinue: () -> Void
    
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
        NavigationStack {
            VStack(spacing: 20) {
                Text("Please choose your preferred language")
                    .font(.title2)
                    .multilineTextAlignment(.center)

                ForEach(languages, id: \.1) { language in
                    Button(language.0) {
                        selectedLanguage = language.1
                        hasCompletedOnboarding = true
                        navigateToNext = true
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding()
            .navigationDestination(isPresented: $navigateToNext) {
                    UserTypeSelectionView { selectedType in
                        print("Selected: \(selectedType)")
                        // Optionally: save to @AppStorage("userType") or advance flow
                    }
                }

            }
        }
    }

// MARK: - Language Selection View
struct LanguageSelectedView: View {
    @Binding var selectedLanguage: String
    var onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Select your preferred language")
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .lineLimit(2)
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
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .padding(.bottom, 30)
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

    
    struct LeaveToRemainGuide: View {
        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    Text("You've been granted Leave to Remain – what next?")
                        .font(.title2)
                        .bold()
                    
                    InfoCard(title: "Apply for Benefits", subtitle: "Apply for Universal Credit immediately.", linkText: "Visit GOV.UK", linkURL: "https://www.gov.uk/browse/benefits")
                    
                    InfoCard(title: "Open a Bank Account", subtitle: "You'll need ID and proof of address.")
                    
                    InfoCard(title: "Find Housing", subtitle: "Your asylum accommodation ends 28 days after your BRP.", linkText: "Apply for council housing", linkURL: "https://www.gov.uk/apply-for-council-housing")
                    
                    InfoCard(title: "Integration Loan", subtitle: "Apply to support rent, education or household costs.", linkText: "Download Form", linkURL: "https://www.gov.uk") // Update to actual link
                    
                    InfoCard(title: "Need Help?", subtitle: "Call Migrant Help or visit your local Jobcentre.")
                }
                .padding()
            }
            .navigationTitle("What To Do Now")
        }
    }
    
    struct InfoCard: View {
        var title: String
        var subtitle: String
        var linkText: String? = nil
        var linkURL: String? = nil
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                if let linkText = linkText, let linkURL = linkURL, let url = URL(string: linkURL) {
                    Link(linkText, destination: url)
                        .font(.callout)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    // Preview
struct OnboardingFlow_Previews: PreviewProvider {
    static var previews: some View {
        let mockLanguage = Binding<String?>(get: { "en" }, set: { _ in })
        
        LanguageSelectionView(selectedLanguage: mockLanguage) {
            print("Continue tapped")
        }
    }
}
