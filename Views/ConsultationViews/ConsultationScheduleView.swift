//
//  ConsultationScheduleView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 04/07/2025.
//

import SwiftUI

struct ConsultationScheduleView: View {
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
