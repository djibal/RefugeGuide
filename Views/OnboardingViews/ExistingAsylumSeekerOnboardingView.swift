//
//  ExistingAsylumSeekerOnboardingView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 17/07/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct ExistingAsylumSeekerOnboardingView: View {
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
        GuideContentView(
            selectedLanguage: selectedLanguage,
            title: localized("Support During Your Asylum Process"),
            subtitle: localized("Essential resources while your application is being processed"),
            cards: guideCards,
            continueButtonText: localized("Continue"),
            onContinue: { showRefEntry = true },
            primaryColor: primaryColor,
            accentColor: accentColor
        )
        .navigationDestination(isPresented: $showRefEntry) {
            EnterReferenceNumberView(
                title: localized("Enter Your Home Office Ref Number"),
                subtitle: localized("Check any letter or card you received from the UK Home Office"),
                placeholder: "A1234567"
            ) { _ in
                onContinue()
            }
        }
    }
        private var guideCards: [GuideCardData] {
            [
                GuideCardData(
                    title: localized("Application Status"),
                    description: localized("Track your asylum application progress and understand next steps"),
                    icon: "clock.fill",
                    linkText: localized("Check Status"),
                    linkURL: "https://www.gov.uk/asylum-process"
                ),
                GuideCardData(
                    title: localized("Healthcare Access"),
                    description: localized("Register for NHS services and mental health support"),
                    icon: "heart.fill",
                    linkText: localized("Healthcare Info"),
                    linkURL: "https://www.redcross.org.uk"
                ),
                GuideCardData(
                    title: localized("Education & Learning"),
                    description: localized("Free courses, language classes, and educational resources"),
                    icon: "graduationcap.fill",
                    linkText: localized("Learning Opportunities"),
                    linkURL: "https://www.refugee-action.org.uk/education"
                ),
                GuideCardData(
                    title: localized("Financial Support"),
                    description: localized("Understand asylum support payments and manage your ASPEN card"),
                    icon: "sterlingsign.circle.fill",
                    linkText: localized("Financial Help"),
                    linkURL: "https://www.gov.uk/asylum-support"
                ),
                GuideCardData(
                    title: localized("Legal Assistance"),
                    description: localized("Free legal advice for your asylum case"),
                    icon: "scale.3d",
                    linkText: localized("Legal Resources"),
                    linkURL: "https://www.freemovement.org.uk"
                ),
                GuideCardData(
                    title: localized("Mental Wellbeing"),
                    description: localized("Counselling services and emotional support"),
                    icon: "brain.head.profile",
                    linkText: localized("Get Support"),
                    linkURL: "https://www.mind.org.uk"
                ),
                GuideCardData(
                    title: localized("Reporting Changes"),
                    description: localized("How to update your address or family circumstances"),
                    icon: "exclamationmark.bubble.fill",
                    linkText: localized("Report Changes"),
                    linkURL: "https://www.gov.uk/report-changes-asylum"
                )
            ]
        }
        
        struct ExistingAsylumSeekerOnboardingView_Previews: PreviewProvider {
            static var previews: some View {
                NavigationView {
                    ExistingAsylumSeekerOnboardingView(onContinue: {})
                }
            }
        }
        
        private func localized(_ key: String) -> String {
            NSLocalizedString(key, comment: "")
        }
    }

