//
//  OnboardingFlow.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 22/06/2025.
//

import SwiftUICore
import SwiftUI

struct OnboardingFlow: View {
    @AppStorage("currentOnboardingStep") var currentStep = 0
    @AppStorage("selectedLanguage") var selectedLanguage: String = ""
    @AppStorage("userType") var userType: UserType = .unknown
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false

    var body: some View {
        ZStack {
            switch currentStep {
            case 0:
                LanguagePickerView {
                    currentStep = 1
                }
            case 1:
                // ❌ FIXED: Removed argument, since WelcomeView takes no params
                WelcomeView()
            case 2:
                UserPathSelectionView(onSelect: { type in
                    userType = type
                    currentStep = 3
                })
            case 3:
                userDestinationView
            default:
                MainTabView()
            }
        }
        .transition(.slide)
        .animation(.easeInOut, value: currentStep)
    }

    @ViewBuilder
    var userDestinationView: some View {
        switch userType {
        case .asylumSeeker:
            IntroToAsylumView(onContinue: completeOnboarding)
        case .existingAsylumSeeker:
            ExistingAsylumVerificationView()  // ✅ FIXED: removed invalid argument
        case .refugee:
            LeaveToRemainGuideView()
        default:
            RegistrationView(onComplete: completeOnboarding)
        }
    }


    func completeOnboarding() {
        hasCompletedOnboarding = true
    }
}
