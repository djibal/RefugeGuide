//
//  UserTypeSelectionView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.

import SwiftUI

struct UserTypeSelectionView: View {
    let onSelect: (RefugeeUserType) -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("Welcome to Refugee Guide")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.accentColor)
            
            Text("How can we help you today?")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Spacer()
            
            VStack(spacing: 20) {
                // Option 1: Planning to seek asylum
                SelectionCard(
                    title: "Are you planning to seek asylum?",
                    description: "Learn about the UK asylum application process",
                    icon: "doc.text.magnifyingglass",
                    color: .blue
                ) {
                    onSelect(.asylumSeeker)
                }
                
                // Option 2: Existing asylum seeker
                SelectionCard(
                    title: "Are you an existing asylum seeker?",
                    description: "Information and support for current applicants",
                    icon: "person.fill.questionmark",
                    color: .orange
                ) {
                    onSelect(.existingAsylumSeeker)
                }
                
                // Option 3: Residence permit granted
                SelectionCard(
                    title: "Have you been granted a residence permit?",
                    description: "Next steps and integration support",
                    icon: "checkmark.shield.fill",
                    color: .green
                ) {
                    onSelect(.refugee)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button("Skip and Register") {
                onSelect(.unknown)
            }
            .foregroundColor(.secondary)
        }
        .padding()
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
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)
                    .frame(width: 50, height: 50)
                    .background(color.opacity(0.2))
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
