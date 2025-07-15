//
//  MoreMenuItem.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 20/07/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct MoreMenuItem: View {
    let title: String
    let icon: String
    let destination: AnyView
    

        var body: some View {
            NavigationLink(destination: destination) {
                VStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(AppColors.accent)
                        .frame(width: 60, height: 60)
                        .background(AppColors.cardBackground)
                        .clipShape(Circle())
                        .shadow(radius: 3)

                    Text(title)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(AppColors.textPrimary)
                        .frame(maxWidth: 80)
                }
                .padding()
            }
        }
    }
