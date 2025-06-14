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

    var body: some Scene {
        WindowGroup {
            AppEntry()
        }
    }
}
