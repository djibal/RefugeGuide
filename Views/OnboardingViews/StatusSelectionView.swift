//
//  StatusSelectionView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct StatusSelectionView: View {
    let selectedLanguage: String
    var onStatusSelected: (RefugeeUserType) -> Void
    
    
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    // Header
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: "person.badge.shield.checkmark.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(primaryColor)
                        
                        Text(statusSelectionTitle)
                            .font(.title2)
                            .bold()
                            .foregroundColor(primaryColor)
                            .lineLimit(nil)
                    }
                    .padding(.bottom, 10)
                    
                    // Status Options
                    VStack(spacing: 15) {
                        StatusOptionCard(
                            title: option1Title,
                            description: option1Description,
                            icon: "questionmark.circle.fill",
                            color: primaryColor
                        ) {
                            onStatusSelected(.asylumSeeker)
                        }
                        
                        StatusOptionCard(
                            title: option2Title,
                            description: option2Description,
                            icon: "person.fill.questionmark",
                            color: accentColor
                        ) {
                            onStatusSelected(.existingAsylumSeeker)
                        }
                        
                        StatusOptionCard(
                            title: option3Title,
                            description: option3Description,
                            icon: "checkmark.shield.fill",
                            color: primaryColor
                        ) {
                            onStatusSelected(.refugee)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(backgroundColor.ignoresSafeArea())
                .id("top")
            }
            .onAppear {
                proxy.scrollTo("top", anchor: .top)
            }
        }
    }
    
    private var statusSelectionTitle: String {
        NSLocalizedString("Choose your status", comment: "Choose your refugee current status")
    }
    
    private var option1Title: String {
        NSLocalizedString("option1Title", comment: "Title for asylum seeker option")
    }

    private var option1Description: String {
        NSLocalizedString("option1Description", comment: "Description for asylum seeker option")
    }

    private var option2Title: String {
        NSLocalizedString("option2Title", comment: "Title for existing asylum seeker option")
    }

    private var option2Description: String {
        NSLocalizedString("option2Description", comment: "Description for existing asylum seeker option")
    }

    private var option3Title: String {
        NSLocalizedString("option3Title", comment: "Title for refugee/residence permit option")
    }

    private var option3Description: String {
        NSLocalizedString("option3Description", comment: "Description for refugee/residence permit option")
    }
    
    struct StatusOptionCard: View {
        let title: String
        let description: String
        let icon: String
        let color: Color
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(color.opacity(0.1))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: icon)
                            .font(.system(size: 20))
                            .foregroundColor(color)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .lineLimit(nil)
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(nil)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(AppColors.textSecondary)

                }
                .padding()
                .background(Color.white)
                .cornerRadius(14)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
