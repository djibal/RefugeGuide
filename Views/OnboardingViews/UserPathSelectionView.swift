//
//  UserPathSelectionView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 08/06/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions

struct UserPathSelectionView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    let selectedLanguage: String
    
    private let primaryColor = Color(red: 0.07, green: 0.36, blue: 0.65)  // Deep UK blue
    private let accentColor = Color(red: 0.94, green: 0.35, blue: 0.15)   // UK accent orange
    private let backgroundColor = Color(red: 0.96, green: 0.96, blue: 0.98)
    
    var body: some View {
        NavigationStack {
            TopAlignedScrollView {  // Replace ScrollView by TopAlignedScrollView
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
                                .lineLimit(nil) // Ensure full text display
                            
                            Text("Please select your current status:")
                                .font(.title3)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil) // Ensure full text display
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            NavigationLink(destination: IntroToAsylumView(onContinue: {
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
                            
                            NavigationLink(destination: ExistingAsylumVerificationView(onVerificationComplete: {
                                hasCompletedOnboarding = true
                            })) {
                                PathOptionCard(
                                    title: "Are you an existing asylum seeker?",
                                    description: "You already have a Home Office reference number",
                                    color: .orange,
                                    iconName: "person.crop.square.filled.and.at.rectangle",
                                    spacing: 10
                                )
                            }
                            
                            NavigationLink(
                                destination: RefugeeGuideContentView(
                                    selectedLanguage: selectedLanguage,
                                    primaryColor: primaryColor,
                                    onContinue: {
                                        hasCompletedOnboarding = true
                                    }
                                )
                            ) {
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
                    .id("top") // Identifier for scrolling
                }
            }
        }
    }
}
