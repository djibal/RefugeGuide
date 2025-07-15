//
//  GrantedAsylumSeekerOnboardingView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 17/07/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct GrantedAsylumSeekerOnboardingView: View {
    let onContinue: () -> Void
    @AppStorage("selectedLanguage") var selectedLanguage: String = "en"
    @State private var showRefEntry = false

    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

    var body: some View {
        VStack {
            GuideContentView(
                selectedLanguage: selectedLanguage,
                title: localized("Building Your New Life in the UK"),
                subtitle: localized("Essential services and support for refugees"),
                cards: guideCards,
                continueButtonText: localized("Continue"),
                onContinue: { showRefEntry = true },
                primaryColor: primaryColor,
                accentColor: accentColor
            )
        }
        .navigationDestination(isPresented: $showRefEntry) {
            EnterReferenceNumberView(
                title: localized("Enter Your BRP or UKVI Number"),
                subtitle: localized("This helps us personalize services for you (e.g. BRP1234567)"),
                placeholder: "BRP1234567"
            ) { _ in
                onContinue()
            }
        }
    }

    private var guideCards: [GuideCardData] {
        [
            GuideCardData(
                title: localized("Financial Support"),
                description: localized("Apply for Universal Credit and other benefits"),
                icon: "sterlingsign.circle.fill",
                linkText: localized("Apply Now"),
                linkURL: "https://www.gov.uk/universal-credit"
            ),
            GuideCardData(
                title: localized("Housing Assistance"),
                description: localized("Find council housing or private rentals"),
                icon: "house.fill",
                linkText: localized("Housing Info"),
                linkURL: "https://www.gov.uk/apply-for-council-housing"
            ),
            GuideCardData(
                title: localized("Healthcare Registration"),
                description: localized("Register with a GP and access NHS services"),
                icon: "stethoscope",
                linkText: localized("Register Now"),
                linkURL: "https://www.nhs.uk/nhs-services/gps/how-to-register-with-a-gp-surgery/"
            ),
            GuideCardData(
                title: localized("Employment Support"),
                description: localized("Job search help, CV building, and training"),
                icon: "briefcase.fill",
                linkText: localized("Job Resources"),
                linkURL: "https://www.refugee-action.org.uk/jobs"
            ),
            GuideCardData(
                title: localized("Family Reunification"),
                description: localized("Bring family members to the UK"),
                icon: "person.2.square.stack",
                linkText: localized("Reunite Family"),
                linkURL: "https://www.refugeecouncil.org.uk/family-reunion"
            ),
            GuideCardData(
                title: localized("Language Learning"),
                description: localized("Free English courses (ESOL) and resources"),
                icon: "text.book.closed",
                linkText: localized("Language Courses"),
                linkURL: "https://www.learndirect.com/learning/english"
            ),
            GuideCardData(
                title: localized("Citizenship Pathway"),
                description: localized("Steps toward British citizenship"),
                icon: "doc.richtext.fill",
                linkText: localized("Learn More"),
                linkURL: "https://www.gov.uk/becoming-a-british-citizen"
            )
        ]
    }

    private func localized(_ key: String) -> String {
        NSLocalizedString(key, comment: "")
    }

    struct GrantedAsylumSeekerOnboardingView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                GrantedAsylumSeekerOnboardingView(onContinue: {})
            }
        }
    }
}

