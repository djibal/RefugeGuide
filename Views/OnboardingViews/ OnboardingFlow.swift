//
//  OnboardingFlow.swift
//  RefugeGuide
//
// Created by Djibal Ramazani on 28/06/2025.
<<<<<<< HEAD

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct OnboardingFlow: View {
=======
import Foundation
import SwiftUI
import FirebaseFunctions

struct OnboardingFlow: View {

    // Shared color constants
    private let primaryColor = Color(red: 0.07, green: 0.36, blue: 0.65)   // Deep UK blue
    private let accentColor = Color(red: 0.94, green: 0.35, blue: 0.15)    // UK orange
    private let backgroundColor = Color(red: 0.96, green: 0.96, blue: 0.98)

>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
    // Steps in onboarding flow
    private enum OnboardingStep: Int {
        case languageSelection
        case welcome
        case userTypeSelection
        case userDestination
        case completed
    }

    // AppStorage bindings
    @AppStorage("currentOnboardingStep") private var currentStepRaw = 0
    @AppStorage("selectedLanguage") var selectedLanguage: String = ""
    @AppStorage("userType") var userType: RefugeeUserType = .unknown
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false

    // Current onboarding step
    private var currentStep: OnboardingStep {
        get { OnboardingStep(rawValue: currentStepRaw) ?? .languageSelection }
        set { currentStepRaw = newValue.rawValue }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.green.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack {
                    switch currentStep {
                    case .languageSelection:
                        LanguageSelectedView(selectedLanguage: $selectedLanguage) {
                            withAnimation {
                                currentStepRaw = OnboardingStep.welcome.rawValue
                            }
                        }

                    case .welcome:
                        WelcomeView {
                            withAnimation {
                                currentStepRaw = OnboardingStep.userTypeSelection.rawValue
                            }
                        }

                    case .userTypeSelection:
                        UserTypeSelectionView { type in
                            userType = type
                            withAnimation {
                                currentStepRaw = OnboardingStep.userDestination.rawValue
                            }
                        }

                    case .userDestination:
                        userDestinationView

                    case .completed:
                        MainTabView()
                    }
                }
            }
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
            .transition(.slide)
            .animation(.easeInOut, value: currentStepRaw)
        }
    }

    // Destination view based on userType
    @ViewBuilder
    private var userDestinationView: some View {
        switch userType {
        case .asylumSeeker, .newAsylumSeeker, .seekingAsylum:
<<<<<<< HEAD
            NewAsylumSeekerOnboardingView(
                onContinue: completeOnboarding, selectedLanguage: selectedLanguage
            )

        case .existingAsylumSeeker:
            ExistingAsylumSeekerOnboardingView(
                onContinue: completeOnboarding, selectedLanguage: selectedLanguage
            )

        case .refugee, .residencePermitHolder, .grantedResidence:
            GrantedAsylumSeekerOnboardingView(
                onContinue: completeOnboarding, selectedLanguage: selectedLanguage
=======
            IntroToAsylumView(
                onContinue: completeOnboarding,
                selectedLanguage: selectedLanguage
            )

        case .existingAsylumSeeker:
            ExistingAsylumVerificationView(
                onVerificationComplete: completeOnboarding,
                selectedLanguage: selectedLanguage
            )

        case .refugee, .residencePermitHolder, .grantedResidence:
            RefugeeGuideContentView(
                selectedLanguage: selectedLanguage,
                primaryColor: primaryColor,
                onContinue: completeOnboarding
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
            )

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
