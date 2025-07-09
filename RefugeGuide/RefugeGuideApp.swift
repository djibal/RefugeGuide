//
//  RefugeGuideApp.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 05/06/2025.
//
//
import SwiftUI
import FirebaseAuth
import FirebaseCore

@main
struct RefugeGuideApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("selectedLanguage") private var selectedLanguage = "en"

    @StateObject private var initViewModel = AppInitializationViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if initViewModel.isFirebaseReady {
                    if hasCompletedOnboarding {
                        if Auth.auth().currentUser != nil {
                            MainTabView()
                        } else {
                            SignInView()
                        }
                    } else {
                        OnboardingFlow()
                    }
                } else {
                    ProgressView("Loading...")
                }
            }
            .environment(\.locale, Locale(identifier: selectedLanguage))
        }
    }
}
