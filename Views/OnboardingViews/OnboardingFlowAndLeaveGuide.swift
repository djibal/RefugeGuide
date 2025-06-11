//
//  LeaveToRemainGuideView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/06/2025.
//
//
// OnboardingFlowAndLeaveGuide.swift
// RefugeGuide

import SwiftUI

struct LanguageSelectionView: View {
    @AppStorage("selectedLanguage") var selectedLanguage: String?
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @State private var navigateToNext = false

    let languages = ["English", "Arabic", "Farsi", "French", "Ukrainian", "Urdu", "Pashto", "Kurdish"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Please choose your preferred language")
                    .font(.title2)
                    .multilineTextAlignment(.center)

                ForEach(languages, id: \.self) { language in
                    Button(language) {
                        selectedLanguage = language
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
                UserTypeSelectionView()
            }
        }
    }
}

    
    struct LeaveToRemainGuideView: View {
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
            LanguageSelectionView()
        }
    }
    

