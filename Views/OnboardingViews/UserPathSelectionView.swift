//
//  UserPathSelectionView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 08/06/2025.
//

import SwiftUI

struct UserPathSelectionView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Refugee Guide")
                    .font(.largeTitle)
                    .bold()

                Text("Please select your current status:")
                    .font(.title3)
                    .multilineTextAlignment(.center)

                VStack(spacing: 16) {
                    NavigationLink(destination: IntroToAsylumView()) {
                        VStack(alignment: .leading) {
                            Text("Are you planning to seek asylum?")
                                .font(.headline)
                            Text("You are starting or planning to start the asylum process in the UK.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }

                    NavigationLink(destination: ExistingAsylumVerificationView()) {
                        VStack(alignment: .leading) {
                            Text("Are you an existing asylum seeker?")
                                .font(.headline)
                            Text("You already have a Home Office reference number.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(12)
                    }

                     NavigationLink(destination: LeaveToRemainGuideView()) {
                        VStack(alignment: .leading) {
                            Text("I have received Leave to Remain")
                                .font(.headline)
                            Text("You now have refugee status or humanitarian protection in the UK.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                    }
                }

                Spacer()

                Button("Skip & Register") {
                    hasCompletedOnboarding = true
                }
                .foregroundColor(.blue)
                .padding(.top)
            }
            .padding()
            .navigationTitle("Get Started")
        }
    }
}
