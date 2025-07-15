//
//  AppDelegate.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 05/06/2025.
//

import UIKit
import FirebaseCore
import CryptoKit

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // ✅ Prevent Firebase from initializing in preview mode
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
            FirebaseApp.configure()
        }

        // Set default language if not already set
        if UserDefaults.standard.string(forKey: "selectedLanguage") == nil {
            UserDefaults.standard.set("en", forKey: "selectedLanguage")
        }

        // ✅ Secure key generation (only if needed)
        generateAndStoreKeyIfNeeded()

        return true
    }

    /// Generates and stores a secure AES-256 key in Keychain if it doesn't already exist
    private func generateAndStoreKeyIfNeeded() {
        if KeychainHelper.loadKeyFromKeychain() == nil {
            let key = SymmetricKey(size: .bits256)
            let keyData = key.withUnsafeBytes { Data(Array($0)) }
            let success = KeychainHelper.saveKeyToKeychain(keyData)
            print(success ? "🔐 Secure key generated and stored in Keychain." :
                            "⚠️ Failed to store encryption key.")
        } else {
            print("✅ Secure encryption key already exists in Keychain.")
        }
    }
}

