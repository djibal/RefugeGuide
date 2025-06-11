//
//  NewAsylumSeekerOnboardingView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/06/2025.
//

// NewAsylumSeekerOnboardingView.swift
// RefugeGuide

import SwiftUI

struct NewAsylumSeekerOnboardingView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Welcome to the UK Asylum Process")
                    .font(.title)
                    .bold()
                
                InfoCard(
                    title: "1. Introduction to the UK asylum process",
                    subtitle: "An overview of how the asylum system works in the UK and what steps you'll go through.",
                    linkText: "View GOV.UK overview",
                    linkURL: "https://www.gov.uk/claim-asylum"
                )

                InfoCard(
                    title: "2. Documents you need",
                    subtitle: "Learn which documents you'll need to support your claim, including identity and travel documents.",
                    linkText: "GOV.UK document checklist",
                    linkURL: "https://www.gov.uk/claim-asylum/documents-you-must-provide"
                )

                InfoCard(
                    title: "3. Screening Interview",
                    subtitle: "This is your first official interview where the Home Office collects your information and biometrics."
                )

                InfoCard(
                    title: "4. Your ARC (Asylum Registration Card)",
                    subtitle: "You’ll receive your ARC after the screening interview. It proves your asylum seeker status."
                )

                InfoCard(
                    title: "5. Substantive Interview & Decision",
                    subtitle: "This is your main interview. The Home Office will assess your claim and decide if you qualify for protection."
                )

                InfoCard(
                    title: "You have the right to legal aid",
                    subtitle: "You can get free legal help during your asylum process if you can’t afford it.",
                    linkText: "Find Legal Help",
                    linkURL: "https://www.gov.uk/legal-aid"
                )
                

                Button("Track My Application") {
                    // Disabled or navigation pending verification
                }
                .disabled(true)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(12)
                .foregroundColor(.gray)
            }
            .padding()
        }
        .navigationTitle("Asylum Guide")
    }
}
