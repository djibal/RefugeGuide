//
//  AppEntry.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import FirebaseAuth

struct AppEntry: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var onboardingStep: Int = 0
    @State private var didAttemptSignIn = false

    var body: some View {
        VStack {
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
        .onAppear {
            if !didAttemptSignIn {
                didAttemptSignIn = true
                if Auth.auth().currentUser == nil {
                    Auth.auth().signInAnonymously { result, error in
                        if let error = error {
                            print("❌ Anonymous sign-in failed: \(error.localizedDescription)")
                        } else {
                            print("✅ Signed in anonymously: \(result?.user.uid ?? "")")
                        }
                    }
                } else {
                    print("ℹ️ Already signed in: \(Auth.auth().currentUser?.uid ?? "Unknown")")
                }
            }
        }
    }
}
