//
//  OnboardingFlow.swift
//  RefugeGuide
//
// Created by Djibal Ramazani on 28/06/2025.

import SwiftUI

struct OnboardingFlow: View {
    private enum OnboardingStep: Int {
        case languageSelection
        case welcome
        case userTypeSelection
        case userDestination
        case completed
    }

    @AppStorage("currentOnboardingStep") private var currentStepRaw = 0
    @AppStorage("selectedLanguage") var selectedLanguage: String = ""
    @AppStorage("userType") var userType: RefugeeUserType = .unknown
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false

    private var currentStep: OnboardingStep {
        get { OnboardingStep(rawValue: currentStepRaw) ?? .languageSelection }
        set { currentStepRaw = newValue.rawValue }
    }

    var body: some View {
        NavigationStack {
            VStack {
                switch currentStep {
                case .languageSelection:
                    LanguageSelectedView(selectedLanguage: $selectedLanguage) {
                        currentStepRaw = OnboardingStep.welcome.rawValue
                    }

                case .welcome:
                    WelcomeView {
                        currentStepRaw = OnboardingStep.userTypeSelection.rawValue
                    }

                case .userTypeSelection:
                    UserTypeSelectionView { type in
                        userType = type
                        currentStepRaw = OnboardingStep.userDestination.rawValue
                    }

                case .userDestination:
                    userDestinationView

                case .completed:
                    MainTabView()
                }
            }
            .animation(.easeInOut, value: currentStepRaw)
            .transition(.slide)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    #if DEBUG
                    Button(action: resetOnboarding) {
                        Label("Reset", systemImage: "arrow.uturn.backward")
                            .labelStyle(IconOnlyLabelStyle())
                    }
                    #endif
                }
            }
        }
    }

    @ViewBuilder
    private var userDestinationView: some View {
        switch userType {
        case .asylumSeeker:
            IntroToAsylumView(onContinue: completeOnboarding)
        case .existingAsylumSeeker:
            ExistingAsylumVerificationView(onVerificationComplete: completeOnboarding)
        case .refugee:
            LeaveToRemainGuideView(onContinue: completeOnboarding)
        case .residencePermitHolder, .grantedResidence:
            LeaveToRemainGuideView(onContinue: completeOnboarding)
        case .newAsylumSeeker, .seekingAsylum:
            IntroToAsylumView(onContinue: completeOnboarding)
        case .unknown:
            RegistrationView(onComplete: completeOnboarding)
        }
    }

    private func completeOnboarding() {
        hasCompletedOnboarding = true
        currentStepRaw = OnboardingStep.completed.rawValue
    }

    private func resetOnboarding() {
        hasCompletedOnboarding = false
        selectedLanguage = ""
        userType = .unknown
        currentStepRaw = 0
    }
}
