//
//  LanguageSelectionView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 29/06/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions
<<<<<<< HEAD
import SwiftUICore
=======
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf

struct LanguageSelectionView: View {
    @Binding var selectedLanguage: String?
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @State private var navigateToNext = false
    var onContinue: () -> Void
    
    private let cardBackground = Color.white
    
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
        NavigationStack {
            TopAlignedScrollView {  //  Replace ScrollView by TopAlignedScrollView
                TopAlignedScrollView {
                    VStack(spacing: 20) {
                        Text("Please choose your preferred language")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil) // Ensure full text display
                        
                        VStack(spacing: 20) {
                            
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
                        .id("top") // Identifier for scrolling
                        .navigationDestination(isPresented: $navigateToNext) {
                            UserTypeSelectionView { selectedType in
                                print("Selected: \(selectedType)")
                            }
                        }
                    }
                }
            }
         }
      }
    
    struct LeaveToRemainGuide: View {
        var body: some View {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        Text("You've been granted Leave to Remain – what next?")
                            .font(.title2)
                            .bold()
                            .lineLimit(nil) // Ensure full text display
                        
                        InfoCard(
                            title: "Apply for Benefits",
                            content: "You may be eligible for government support after receiving asylum.",
                            icon: "creditcard.fill",
                            color: .blue,
                            subtitle: "Apply for Universal Credit immediately.",
                            linkText: "Visit GOV.UK",
                            linkURL: "https://www.gov.uk/browse/benefits"
                        )
                        
                        InfoCard(
                            title: "Open a Bank Account",
                            content: "Opening a bank account will help you receive payments and wages.",
                            icon: "banknote.fill", color: .green,
                            subtitle: "You'll need ID and proof of address."
                        )
                        
                        InfoCard(
                            title: "Find Housing",
                            content: "Start looking for long-term housing options as early as possible.",
                            icon: "house.fill",
                            color: .orange,
                            subtitle: "Your asylum accommodation ends 28 days after your BRP.",
                            linkText: "Apply for council housing",
                            linkURL: "https://www.gov.uk/apply-for-council-housing"
                        )
                        
                        InfoCard(
                            title: "Integration Loan",
                            content: "You can apply for a loan to support your transition.",
                            icon: "dollarsign.circle.fill",
                            color: .purple,
                            subtitle: "Apply to support rent, education or household costs.",
                            linkText: "Download Form",
                            linkURL: "https://www.gov.uk"
                        )
                        
                        InfoCard(
                            title: "Need Help?",
                            content: "There are support lines and centres that can assist with urgent needs.",
                            icon: "questionmark.circle.fill",
                            color: .red,
                            subtitle: "Call Migrant Help or visit your local Jobcentre."
                        )
                    }
                    .padding()
                    .id("top") // Identifier for scrolling
                }
                .navigationTitle("What To Do Now")
                .onAppear {
                    proxy.scrollTo("top", anchor: .top)
                }
            }
        }
    }
    
    struct InfoCard: View {
        let title: String
        let content: String
        let icon: String
        let color: Color
        var subtitle: String
        var linkText: String? = nil
        var linkURL: String? = nil
        
        private let cardBackground = Color.white
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                if !title.isEmpty {
                    HStack {
                        Image(systemName: icon)
                            .foregroundColor(color)
                        Text(title)
                            .font(.headline)
                            .foregroundColor(color)
                            .lineLimit(nil) // Ensure full text display
                    }
                }
                
                if !content.isEmpty {
                    Text(content)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.top, 5)
                        .lineLimit(nil) // Ensure full text display
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(cardBackground)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
        }
    }
    
    struct OnboardingFlow_Previews: PreviewProvider {
        static var previews: some View {
            let mockLanguage = Binding<String?>(get: { "en" }, set: { _ in })
            
            LanguageSelectionView(selectedLanguage: mockLanguage) {
                print("Continue tapped")
            }
        }
    }
}

