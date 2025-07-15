
//
//  AppConfigurator.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import UIKit

class AppConfigurator {
    
    static func configureAppEnvironment() {
        configureAppearance()
        configureAnalytics()
        configureSecurity()
        configureLocalization()
        printAppEnvironmentInfo()
    }
    
    private static func configureAppearance() {
        // Global UI appearance configuration
        let accentColor = UIColor(named: "AccentColor") ?? .systemBlue
        
        UINavigationBar.appearance().tintColor = accentColor
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.label
        ]
        
        UITabBar.appearance().tintColor = accentColor
        UITabBar.appearance().unselectedItemTintColor = .secondaryLabel
        
        UITableView.appearance().backgroundColor = .clear
        UICollectionView.appearance().backgroundColor = .clear
    }
    
    private static func configureAnalytics() {
        // Placeholder for analytics setup (e.g., AppCenter)
        #if DEBUG
        print("Analytics disabled in debug mode")
        #else
        // Initialize production analytics here
        // AnalyticsManager.start()
        #endif
    }
    
    private static func configureSecurity() {
        // Enable security protections
        URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        
        // Keychain configuration
        KeychainWrapper.standard.set("AppSecureSalt", forKey: "securitySalt")
        
        // HTTP security headers
        URLSessionConfiguration.default.httpAdditionalHeaders = [
            "Content-Security-Policy": "default-src 'self'",
            "X-Content-Type-Options": "nosniff"
        ]
    }
    
    private static func configureLocalization() {
        // UK-specific localization defaults
        if UserDefaults.standard.string(forKey: "AppleLanguage") == nil {
            UserDefaults.standard.set(["en-GB"], forKey: "AppleLanguages")
        }
    }
    
    private static func printAppEnvironmentInfo() {
        #if DEBUG
        let environment = "DEBUG"
        #else
        let environment = "RELEASE"
        #endif
        
        print("""
        RefugeGuide Configuration Complete
        ---------------------------------
        Environment: \(environment)
        Version: \(Bundle.main.versionNumber) (\(Bundle.main.buildNumber))
        Locale: \(Locale.current.identifier)
        Timezone: \(TimeZone.current.identifier)
        """)
    }
    
    static func handleLaunchOptions(_ options: [UIApplication.LaunchOptionsKey: Any]?) {
        // Handle deep links from cold start
        if let url = options?[.url] as? URL {
            DeepLinkManager.handleDeepLink(url)
        }
    }
}

// MARK: - Bundle Extension
extension Bundle {
    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}

// MARK: - Keychain Wrapper
struct KeychainWrapper {
    static let standard = KeychainWrapper()
    private init() {}
    
    func set(_ value: String, forKey key: String) {
        let data = Data(value.utf8)
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary
        
        SecItemDelete(query)
        SecItemAdd(query, nil)
    }
}

// MARK: - Deep Link Manager
class DeepLinkManager {
    static func handleDeepLink(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host else {
            return
        }
        
        let pathComponents = components.path.split(separator: "/")
        
        switch host {
        case "resources":
            if let resourceId = pathComponents.first {
                NavigationCoordinator.shared.navigateToResource(String(resourceId))
            }
        case "community":
            NavigationCoordinator.shared.navigateToCommunity()
        case "safety":
            NavigationCoordinator.shared.navigateToSafetyPlanning()
        default:
            break
        }
    }
}

// MARK: - Navigation Coordinator
class NavigationCoordinator: ObservableObject {
    static let shared = NavigationCoordinator()
    
    @Published var currentDestination: AppDestination?
    
    enum AppDestination: Hashable {
        case resource(String)
        case community
        case safetyPlanning
    }
    
    func navigateToResource(_ id: String) {
        currentDestination = .resource(id)
    }
    
    func navigateToCommunity() {
        currentDestination = .community
    }
    
    func navigateToSafetyPlanning() {
        currentDestination = .safetyPlanning
    }
}
