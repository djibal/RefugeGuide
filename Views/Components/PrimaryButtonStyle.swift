//
//  PrimaryButtonStyle.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 30/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions

struct PrimaryButtonStyle: ButtonStyle {
    let backgroundColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .shadow(color: backgroundColor.opacity(0.3), radius: 5, x: 0, y: 3)
            .buttonStyle(PrimaryButtonStyle(backgroundColor: AppColors.primary))

    }
}
