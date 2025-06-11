//
//  UserTypeSelectionView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
//


import SwiftUI

struct UserTypeSelectionView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Text("Please select your current status.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            VStack(spacing: 16) {
                NavigationLink(destination: NewAsylumSeekerOnboardingView()) {
                    VStack {
                        Text("Are you planning to seek asylum?")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)

                        Text("You are starting or planning to start the asylum process in the UK.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                    }
                }

                NavigationLink(destination: ExistingAsylumVerificationView()) {
                    VStack {
                        Text("I am an existing asylum seeker")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(12)

                        Text("You already have a Home Office reference number.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                    }
                }

                // ✅ New section: Leave to Remain
                NavigationLink(destination: LeaveToRemainGuideView()) {
                    VStack {
                        Text("I have received Leave to Remain")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)

                        Text("You now have refugee status or humanitarian protection in the UK.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("User Type")
    }
}

#Preview {
    UserTypeSelectionView()
}
