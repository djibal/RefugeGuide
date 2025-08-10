//
//  ConsultationScheduleView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 04/07/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions
<<<<<<< HEAD
import SwiftUICore
=======
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf

struct ConsultationScheduleView: View {
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Schedule a Consultation")
                .font(.title2)
                .bold()

            Text("This screen will allow users to book an appointment with a legal advisor or support professional.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            Button("Dismiss") {
                // TODO: Add dismiss logic if needed
            }
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}
