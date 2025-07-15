//
//  UserPathSelectionView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 08/06/2025.
//
//

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct UserPathSelectionView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    let selectedLanguage: String
    
    let primaryColor = Color(hex: "#0D3B66")  // Rich blue
    let accentColor = Color(hex: "#F95738")   // Bright coral-red
    let cardColor = Color(hex: "#FFFFFF")     // White
    let backgroundColor = Color(hex: "#F5F9FF") // Soft blue-white
    let textPrimary = Color(hex: "#1A1A1A")   // Neutral dark
    let textSecondary = Color(hex: "#555555") // Medium gray
    
    var body: some View {
        NavigationStack {
            TopAlignedScrollView {
                TopAlignedScrollView {
                    VStack(spacing: 30) {
                        VStack(spacing: 15) {
                            Image(systemName: "figure.walk.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(primaryColor)

                            Text("Refugee Guide")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(primaryColor)
                                .lineLimit(nil)

                            Text("Please select your current status:")
                                .font(.title3)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                        }
                        .padding(.top, 20)

                        VStack(spacing: 20) {
                            NavigationLink(destination: NewAsylumSeekerOnboardingView(onContinue: {
                                hasCompletedOnboarding = true
                                
                            })) {
                                PathOptionCard(
                                    title: "Are you planning to seek asylum?",
                                    description: "You are starting or planning to start the asylum process in the UK",
                                    color: .blue,
                                    iconName: "person.fill.questionmark",
                                    spacing: 10
                                )
                            }

                            NavigationLink(destination: ExistingAsylumSeekerOnboardingView(
                                onContinue: {
                                    hasCompletedOnboarding = true
                                }, selectedLanguage: selectedLanguage)) {
                                PathOptionCard(
                                    title: "Are you an existing asylum seeker?",
                                    description: "You already have a Home Office reference number",
                                    color: .orange,
                                    iconName: "person.crop.square.filled.and.at.rectangle",
                                    spacing: 10
                                )
                            }

                            NavigationLink(destination: GrantedAsylumSeekerOnboardingView(
                                onContinue: {
                                    hasCompletedOnboarding = true
                                }, selectedLanguage: selectedLanguage)) {
                                PathOptionCard(
                                    title: "I have received Leave to Remain",
                                    description: "You now have refugee status or humanitarian protection in the UK",
                                    color: .green,
                                    iconName: "checkmark.seal.fill",
                                    spacing: 10
                                )
                            }

                            Spacer()

                            Button("Skip & Register") {
                                hasCompletedOnboarding = true
                            }
                            .font(.subheadline)
                            .foregroundColor(primaryColor)
                            .padding(.bottom, 30)
                        }
                    }
                    .id("top")
                }
            }
        }
    }
}
