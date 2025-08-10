//
//  UserTypeSelectionView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
import Foundation
import SwiftUI
import FirebaseFunctions
<<<<<<< HEAD
import SwiftUICore
=======
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf

struct UserTypeSelectionView: View {
    let onSelect: (RefugeeUserType) -> Void
    
<<<<<<< HEAD
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")
=======
    private let primaryColor = Color(red: 0.07, green: 0.36, blue: 0.65)  // Deep UK blue
    private let accentColor = Color(red: 0.94, green: 0.35, blue: 0.15)   // UK accent orange
    private let backgroundColor = Color(red: 0.96, green: 0.96, blue: 0.98)
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
    
    var body: some View {
        TopAlignedScrollView {   // Replace ScrollViewReader and ScrollView by  TopAlignedScrollView
            TopAlignedScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 15) {
                        Image(systemName: "hand.wave.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(primaryColor)
                        
                        Text("Welcome to UK Refugee Guide")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(primaryColor)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("Your trusted companion through the UK asylum process")
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 30)
                    .padding(.horizontal)
                    
                    VStack(spacing: 20) {
                        SelectionCard(
                            title: "Are you planning to seek asylum?",
                            description: "Learn about the UK asylum application process",
                            icon: "doc.text.magnifyingglass",
                            color: primaryColor
                        ) {
                            onSelect(.asylumSeeker)
                        }
                        
                        SelectionCard(
                            title: "Are you an existing asylum seeker?",
                            description: "Information and support for current applicants",
                            icon: "person.fill.questionmark",
                            color: accentColor
                        ) {
                            onSelect(.existingAsylumSeeker)
                        }
                        
                        SelectionCard(
                            title: "Have you been granted a residence permit?",
                            description: "Next steps and integration support",
                            icon: "checkmark.shield.fill",
                            color: primaryColor
                        ) {
                            onSelect(.refugee)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button("Skip and Register") {
                        onSelect(.unknown)
                    }
                    .font(.subheadline)
                    .foregroundColor(primaryColor)
                    .padding(.bottom, 30)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(backgroundColor.ignoresSafeArea())
                .id("top") // Identifier for scrolling
            }
        }
    }
    
    struct SelectionCard: View {
        let title: String
        let description: String
        let icon: String
        let color: Color
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(color.opacity(0.1))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: icon)
                            .font(.title2)
                            .foregroundColor(color)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
<<<<<<< HEAD
                        .foregroundColor(AppColors.textSecondary)

=======
                        .foregroundColor(.gray)
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
