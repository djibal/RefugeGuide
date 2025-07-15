//
//  CategoryInfoView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 12/07/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct CategoryInfoView: View {
    let title: String
    let description: String
    let benefits: [String]
    let onContinue: () -> Void
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

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
                            .background(AppColors.primary)
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
