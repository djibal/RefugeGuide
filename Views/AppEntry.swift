//
//  AppEntry.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/06/2025.
//

// AppEntry.swift
// RefugeGuide
import SwiftUI

struct AppEntry: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var onboardingStep: Int = 0

    var body: some View {
        if hasCompletedOnboarding {
            MainTabView()
        } else {
            switch onboardingStep {
            case 0:
                LanguagePickerView(onContinue: {
                    onboardingStep += 1
                })
            case 1:
                IntroToAsylumView(onContinue: {
                    onboardingStep += 1
                })
            case 2:
                DocumentChecklistView(onFinish: {
                    hasCompletedOnboarding = true
                })
            default:
                EmptyView()
            }
        }
    }
}
