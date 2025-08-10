//
//  CategoryInfoView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 12/07/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
<<<<<<< HEAD
import SwiftUICore
=======
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf

struct CategoryInfoView: View {
    let title: String
    let description: String
    let benefits: [String]
    let onContinue: () -> Void
    
<<<<<<< HEAD
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")
=======
    private let primaryColor = Color(red: 0.07, green: 0.36, blue: 0.65)
    private let accentColor = Color(red: 0.94, green: 0.35, blue: 0.15)
    private let backgroundColor = Color(red: 0.96, green: 0.96, blue: 0.98)
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                        .lineLimit(nil)

                    Text(description)
                        .font(.headline)
                        .padding(.top, 8)
                        .lineLimit(nil)

                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(benefits, id: \.self) { benefit in
                            Label(benefit, systemImage: "checkmark.circle.fill")
                                .foregroundColor(primaryColor)
                                .lineLimit(nil)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 3)

                    Button(action: onContinue) {
                        Text("Continue")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(primaryColor)
                            .foregroundColor(.white)
<<<<<<< HEAD
                            .background(AppColors.primary)
=======
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
                            .cornerRadius(12)
                            .lineLimit(nil)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
                .padding(.top, 24)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .id("top")
            }
            .background(backgroundColor.ignoresSafeArea())
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                proxy.scrollTo("top", anchor: .top)
            }
        }
    }
}
