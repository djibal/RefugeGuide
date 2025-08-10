//
//  ErrorView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 30/06/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions
<<<<<<< HEAD
import SwiftUICore
=======
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
<<<<<<< HEAD
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")
    
=======
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Processing Error")
                .font(.title2)
            
            Text(message)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Try Again", action: onRetry)
                .buttonStyle(PrimaryButtonStyle(backgroundColor: .blue)) // or whatever color you want
            
                .padding()
        }
        
    }

    struct PrimaryButtonStyle: ButtonStyle {
        var backgroundColor: Color = .blue // ✅ Default value

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .background(backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(8)
                .opacity(configuration.isPressed ? 0.7 : 1.0)
        }
    }

}
