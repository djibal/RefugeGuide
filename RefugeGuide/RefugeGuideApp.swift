//
//  RefugeGuideApp.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 05/06/2025.
//
//
import Foundation
import SwiftUI
import FirebaseFunctions
import FirebaseAuth
import FirebaseCore

@main
struct RefugeGuideApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("selectedLanguage") private var selectedLanguage = "en"

    @StateObject private var initViewModel = AppInitializationViewModel()
<<<<<<< HEAD
    @StateObject private var authVM = AuthenticationViewModel()

    @State private var showSplash = true
=======
    @StateObject private var authVM = AuthenticationViewModel() // ✅ Injected ViewModel
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashScreenView()
                        .transition(.opacity)
                        .onAppear {
                            // Auto-dismiss splash after 3.5 seconds (adjust to match animation)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                withAnimation {
                                    showSplash = false
                                }
                            }
                        }
                } else {
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
                    .environmentObject(authVM)
                }
            }
<<<<<<< HEAD
=======
            .environment(\.locale, Locale(identifier: selectedLanguage))
            .environmentObject(authVM) // ✅ Inject here for use in ProfileView and others
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
        }
    }
}
