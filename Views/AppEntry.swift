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
import SwiftUICore

struct AppEntry: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("userType") private var userType: RefugeeUserType = .unknown
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"
    @AppStorage("hasCompletedInitialSetup") private var hasCompletedInitialSetup = false

    @State private var didAttemptSignIn = false

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingFlow()
            }
        }
        .onAppear {
            attemptAnonymousSignIn()
        }
    }

    private func attemptAnonymousSignIn() {
        guard !didAttemptSignIn else { return }
        didAttemptSignIn = true

        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { result, error in
                if let error = error {
                    print("❌ Anonymous sign-in failed: \(error.localizedDescription)")
                } else if let user = result?.user {
                    print("✅ Signed in anonymously: \(user.uid)")
                }
            }
        } else {
            print("ℹ️ Already signed in: \(Auth.auth().currentUser?.uid ?? "Unknown")")
        }
    }
}
