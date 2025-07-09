//
//  AppDelegate.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 05/06/2025.
//
import UIKit
import FirebaseCore

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
        
        return true
    }
}
