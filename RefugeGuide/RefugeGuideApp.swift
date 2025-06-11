//
//  RefugeGuideApp.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 05/06/2025.
//
import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct RefugeGuideApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
        print("🟡 App init started")

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

    var body: some Scene {
        WindowGroup {
            AppEntry() // or SignInView()
        }
    }
}
