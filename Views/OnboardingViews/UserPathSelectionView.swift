//
//  UserPathSelectionView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 08/06/2025.
//
<<<<<<< HEAD
//

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore
=======
import Foundation
import SwiftUI
import FirebaseFunctions
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf

struct UserPathSelectionView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    let selectedLanguage: String
    
<<<<<<< HEAD
    let primaryColor = Color(hex: "#0D3B66")  // Rich blue
    let accentColor = Color(hex: "#F95738")   // Bright coral-red
    let cardColor = Color(hex: "#FFFFFF")     // White
    let backgroundColor = Color(hex: "#F5F9FF") // Soft blue-white
    let textPrimary = Color(hex: "#1A1A1A")   // Neutral dark
    let textSecondary = Color(hex: "#555555") // Medium gray
    
    var body: some View {
        NavigationStack {
            TopAlignedScrollView {
=======
    private let primaryColor = Color(red: 0.07, green: 0.36, blue: 0.65)  // Deep UK blue
    private let accentColor = Color(red: 0.94, green: 0.35, blue: 0.15)   // UK accent orange
    private let backgroundColor = Color(red: 0.96, green: 0.96, blue: 0.98)
    
    var body: some View {
        NavigationStack {
            TopAlignedScrollView {  // Replace ScrollView by TopAlignedScrollView
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
                TopAlignedScrollView {
                    VStack(spacing: 30) {
                        VStack(spacing: 15) {
                            Image(systemName: "figure.walk.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(primaryColor)
<<<<<<< HEAD

=======
                            
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
                            Text("Refugee Guide")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(primaryColor)
<<<<<<< HEAD
                                .lineLimit(nil)

=======
                                .lineLimit(nil) // Ensure full text display
                            
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
                            Text("Please select your current status:")
                                .font(.title3)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
<<<<<<< HEAD
                                .lineLimit(nil)
                        }
                        .padding(.top, 20)

                        VStack(spacing: 20) {
                            NavigationLink(destination: NewAsylumSeekerOnboardingView(onContinue: {
                                hasCompletedOnboarding = true
                                
=======
                                .lineLimit(nil) // Ensure full text display
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            NavigationLink(destination: IntroToAsylumView(onContinue: {
                                hasCompletedOnboarding = true
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
                            })) {
                                PathOptionCard(
                                    title: "Are you planning to seek asylum?",
                                    description: "You are starting or planning to start the asylum process in the UK",
                                    color: .blue,
                                    iconName: "person.fill.questionmark",
                                    spacing: 10
                                )
                            }
<<<<<<< HEAD

                            NavigationLink(destination: ExistingAsylumSeekerOnboardingView(
                                onContinue: {
                                    hasCompletedOnboarding = true
                                }, selectedLanguage: selectedLanguage)) {
=======
                            
                            NavigationLink(destination: ExistingAsylumVerificationView(onVerificationComplete: {
                                hasCompletedOnboarding = true
                            })) {
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
                                PathOptionCard(
                                    title: "Are you an existing asylum seeker?",
                                    description: "You already have a Home Office reference number",
                                    color: .orange,
                                    iconName: "person.crop.square.filled.and.at.rectangle",
                                    spacing: 10
                                )
                            }
<<<<<<< HEAD

                            NavigationLink(destination: GrantedAsylumSeekerOnboardingView(
                                onContinue: {
                                    hasCompletedOnboarding = true
                                }, selectedLanguage: selectedLanguage)) {
=======
                            
                            NavigationLink(
                                destination: RefugeeGuideContentView(
                                    selectedLanguage: selectedLanguage,
                                    primaryColor: primaryColor,
                                    onContinue: {
                                        hasCompletedOnboarding = true
                                    }
                                )
                            ) {
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
                                PathOptionCard(
                                    title: "I have received Leave to Remain",
                                    description: "You now have refugee status or humanitarian protection in the UK",
                                    color: .green,
                                    iconName: "checkmark.seal.fill",
                                    spacing: 10
                                )
                            }
<<<<<<< HEAD

                            Spacer()

=======
                            
                            Spacer()
                            
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
                            Button("Skip & Register") {
                                hasCompletedOnboarding = true
                            }
                            .font(.subheadline)
                            .foregroundColor(primaryColor)
                            .padding(.bottom, 30)
                        }
                    }
<<<<<<< HEAD
                    .id("top")
=======
                    .id("top") // Identifier for scrolling
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
                }
            }
        }
    }
}
