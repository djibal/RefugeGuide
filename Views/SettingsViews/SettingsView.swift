//
//  SettingsView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/06/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions
<<<<<<< HEAD
import SwiftUICore
=======
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf


struct SettingsView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage = "en"
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    @AppStorage("isNotificationsEnabled") private var isNotificationsEnabled = true
    @AppStorage("appTheme") private var appTheme = "System"

    @State private var showLanguagePicker = false
    @State private var showLogoutConfirmation = false
    @State private var showResetOnboarding = false
    @State private var showPrivacyPolicy = false
    @State private var cacheSize = "Calculating..."

    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var systemColorScheme

    private let themes = ["System", "Light", "Dark"]
    
    let primaryColor = Color(hex: "#0D3B66")  // Rich blue
    let accentColor = Color(hex: "#F95738")   // Bright coral-red
    let cardColor = Color(hex: "#FFFFFF")     // White
    let backgroundColor = Color(hex: "#F5F9FF") // Soft blue-white
    let textPrimary = Color(hex: "#1A1A1A")   // Neutral dark
    let textSecondary = Color(hex: "#555555") // Medium gray


    var body: some View {
        NavigationView {
            List {
                // Preferences
                Section(header: Text("Preferences")) {
                    languageSetting
                    themeSetting
                    notificationSetting
                }

                // Account
                Section(header: Text("Account")) {
                    logoutButton
                    resetOnboardingButton
                }

                // Support
                Section(header: Text("Support")) {
                    helpSupportLink
                    privacyPolicyButton
                    clearCacheButton
                }

                // App Info
                Section {
                    appVersionInfo
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showLanguagePicker) {
                LanguagePickerView(
                    selectedLanguage: selectedLanguage,   // ✅ remove the '$'
                    onContinue: {
                        showLanguagePicker = false        // ✅ dismiss on continue
                    }
                )
            }

            .confirmationDialog("Log Out", isPresented: $showLogoutConfirmation) {
                logoutConfirmationDialog
            }
            .alert("Reset Onboarding?", isPresented: $showResetOnboarding) {
                Button("Reset", role: .destructive) {
                    hasCompletedOnboarding = false
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will show the initial setup screens next time you open the app.")
            }
            .sheet(isPresented: $showPrivacyPolicy) {
                PrivacyPolicyView()
            }
            .onAppear(perform: calculateCacheSize)
        }
        .environment(\.colorScheme, resolveTheme() ?? .light)
        .navigationViewStyle(.stack)
    }

    // MARK: - Settings Components

    private var languageSetting: some View {
        Button {
            showLanguagePicker = true
        } label: {
            HStack {
                Label("Language", systemImage: "globe")
                Spacer()
                Text(localizedLanguageName)
                    .foregroundColor(.secondary)
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
        }
    }

    private var themeSetting: some View {
        Picker(selection: $appTheme) {
            ForEach(themes, id: \.self) { theme in
                Text(theme)
            }
        } label: {
            Label("Appearance", systemImage: "moon.stars")
        }
    }

    private var notificationSetting: some View {
        Toggle(isOn: $isNotificationsEnabled) {
            Label("Notifications", systemImage: "bell.badge")
        }
    }

    private var logoutButton: some View {
        Button(role: .destructive) {
            showLogoutConfirmation = true
        } label: {
            Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
        }
    }

    private var resetOnboardingButton: some View {
        Button {
            showResetOnboarding = true
        } label: {
            Label("Reset Onboarding", systemImage: "arrow.uturn.backward")
        }
    }

    private var helpSupportLink: some View {
        NavigationLink(destination: HelpResourcesView()) {
            Label("Help & Support", systemImage: "questionmark.circle")
        }
    }

    private var privacyPolicyButton: some View {
        Button {
            showPrivacyPolicy = true
        } label: {
            Label("Privacy Policy", systemImage: "hand.raised")
        }
    }

    private var clearCacheButton: some View {
        Button {
            clearAppCache()
        } label: {
            Label {
                HStack {
                    Text("Clear Cache")
                    Spacer()
                    Text(cacheSize)
                        .foregroundColor(.secondary)
                }
            } icon: {
                Image(systemName: "trash")
            }
        }
        .disabled(cacheSize == "0 KB")
    }

    private var appVersionInfo: some View {
        HStack {
            Label("RefugeGuide", systemImage: "app.badge")
            Spacer()
            Text(appVersion)
                .foregroundColor(.secondary)
        }
    }

    private var logoutConfirmationDialog: some View {
        VStack {
            Button("Log Out", role: .destructive) {
                handleLogout()
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    // MARK: - Computed

    private var localizedLanguageName: String {
        Locale.current.localizedString(forIdentifier: selectedLanguage) ?? selectedLanguage.uppercased()
    }

    private var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return "v\(version) (\(build))"
        }
        return "v1.0"
    }

    private func resolveTheme() -> ColorScheme? {
        switch appTheme {
        case "Light": return .light
        case "Dark": return .dark
        default: return nil
        }
    }

    // MARK: - Actions

    private func handleLogout() {
        // Implement logout logic (e.g., FirebaseAuth)
        print("User logged out")
        hasCompletedOnboarding = false

        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }

    private func calculateCacheSize() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let sizeInKB = Int.random(in: 0...1024)
            cacheSize = sizeInKB > 0 ? "\(sizeInKB) KB" : "0 KB"
        }
    }

    private func clearAppCache() {
        print("Cache cleared")
        cacheSize = "0 KB"

        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
}

// MARK: - Privacy Policy Sheet

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Privacy Policy")
                        .font(.largeTitle)
                        .bold()

                    Text("Effective Date: August 1, 2023")
                        .foregroundColor(.secondary)

                    privacySection(
                        title: "1. Information We Collect",
                        content: "We collect personal information you provide when using RefugeGuide, such as name, email, and asylum application details. We also automatically collect usage data through analytics tools."
                    )

                    privacySection(
                        title: "2. How We Use Information",
                        content: "Your information is used to provide personalized services, improve app functionality, and connect you with relevant support resources. We never sell your data to third parties."
                    )

                    privacySection(
                        title: "3. Data Security",
                        content: "We implement industry-standard security measures including encryption, secure servers, and regular audits to protect your sensitive information."
                    )

                    privacySection(
                        title: "4. GDPR Compliance",
                        content: "For users in the UK and EU, we comply with GDPR regulations. You have the right to access, correct, or delete your personal data at any time."
                    )

                    Text("Contact us at privacy@refugeguide.org for any privacy-related concerns.")
                        .padding(.top)
                }
                .padding()
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func privacySection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(content)
        }
    }
}
