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
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    let selectedLanguage: String

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "figure.walk.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 84, height: 84)
                            .foregroundColor(AppColors.primary)

                        Text("Refugee Guide")
                            .font(.largeTitle.bold())
                            .foregroundColor(AppColors.primary)

                        Text("Please select your current status:")
                            .font(.title3)
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 24)

                    // Options
                    VStack(spacing: 16) {

                        // 1) Planning to seek asylum
                        NavigationLink {
                            NewAsylumSeekerOnboardingView(
                                onContinue: { hasCompletedOnboarding = true },
                                selectedLanguage: selectedLanguage
                            )
                        } label: {
                            UserPathOptionCard(
                                title: "Are you planning to seek asylum?",
                                description: "You are starting or planning to start the asylum process in the UK.",
                                iconName: "person.fill.questionmark",
                                color: AppColors.primary
                            )
                        }

                        // 2) Existing asylum seeker
                        NavigationLink {
                            ExistingAsylumSeekerOnboardingView(
                                onContinue: { hasCompletedOnboarding = true },
                                selectedLanguage: selectedLanguage
                            )
                        } label: {
                            UserPathOptionCard(
                                title: "Are you an existing asylum seeker?",
                                description: "You already have a Home Office reference number.",
                                iconName: "person.crop.square.filled.and.at.rectangle",
                                color: AppColors.accent
                            )
                        }

                        // 3) Granted / Leave to Remain
                        NavigationLink {
                            GrantedAsylumSeekerOnboardingView(
                                onContinue: { hasCompletedOnboarding = true },
                                selectedLanguage: selectedLanguage
                            )
                        } label: {
                            UserPathOptionCard(
                                title: "I have received Leave to Remain",
                                description: "You now have refugee status or humanitarian protection in the UK.",
                                iconName: "checkmark.seal.fill",
                                color: .green
                            )
                        }
                    }

                    // Skip
                    Button {
                        hasCompletedOnboarding = true
                    } label: {
                        Text("Skip & Register")
                            .font(.subheadline)
                            .foregroundColor(AppColors.primary)
                    }
                    .padding(.bottom, 32)
                }
                .padding(.horizontal, 20)
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationTitle("Welcome")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Card (local, with default spacing and custom init)

private struct UserPathOptionCard: View {
    let title: String
    let description: String
    let iconName: String
    let color: Color
    let spacing: CGFloat

    init(
        title: String,
        description: String,
        iconName: String,
        color: Color,
        spacing: CGFloat = 14   // default so calls don’t need to pass it
    ) {
        self.title = title
        self.description = description
        self.iconName = iconName
        self.color = color
        self.spacing = spacing
    }

    var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            Image(systemName: iconName)
                .imageScale(.large)
                .font(.system(size: 26, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 34, height: 34)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(AppColors.textPrimary)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppColors.cardBackground)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#if DEBUG
struct PathSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        UserPathSelectionView(selectedLanguage: "en")
            .previewDisplayName("User Path Selection")
    }
}
#endif
