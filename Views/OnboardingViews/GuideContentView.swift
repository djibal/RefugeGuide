//
//  GuideContentView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct GuideContentView: View {
    let selectedLanguage: String
    let title: String
    let subtitle: String
    let cards: [GuideCardData]
    let continueButtonText: String
    var onContinue: () -> Void
    
    let primaryColor: Color
    let accentColor: Color
    
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")
    

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    // Header
                    VStack(alignment: .leading, spacing: 15) {
                        Text(title)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(primaryColor)
                            .lineLimit(nil)
                        
                        Text(subtitle)
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .lineLimit(nil)
                    }
                    .padding(.bottom, 10)
                    
                    // Cards
                    VStack(spacing: 20) {
                        ForEach(cards) { card in
                            UserGuideCard(
                                title: card.title,
                                description: card.description,
                                icon: card.icon,
                                linkText: card.linkText,
                                linkURL: card.linkURL,
                                primaryColor: primaryColor,
                                accentColor: accentColor
                            )
                        }
                    }
                    
                    Spacer()
                    
                    // Continue Button
                    Button(action: onContinue) {
                        Text(continueButtonText)
                            .font(.headline)
                            .foregroundColor(.white)
                            .background(AppColors.primary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(primaryColor)
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                            .shadow(color: primaryColor.opacity(0.3), radius: 5, x: 0, y: 3)
                            .lineLimit(nil)
                    }
                    .padding(.bottom, 20)
                }
                .padding()
                .background(backgroundColor.ignoresSafeArea())
                .id("top")
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                proxy.scrollTo("top", anchor: .top)
            }
        }
    }
}

struct UserGuideCard: View {
    let title: String
    let description: String
    let icon: String
    var linkText: String?
    var linkURL: String?
    let primaryColor: Color
    let accentColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                ZStack {
                    Circle()
                        .fill(primaryColor.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .foregroundColor(primaryColor)
                        .font(.system(size: 20))
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(primaryColor)
                        .lineLimit(nil)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(nil)
                    
                    if let linkText = linkText, let linkURL = linkURL {
                        Link(destination: URL(string: linkURL)!) {
                            HStack(spacing: 4) {
                                Text(linkText)
                                    .lineLimit(nil)
                                Image(systemName: "arrow.up.forward")
                            }
                            .font(.callout)
                            .foregroundColor(accentColor)
                            .padding(.top, 4)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
}
