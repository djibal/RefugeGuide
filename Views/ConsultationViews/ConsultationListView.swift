//
//  ConsultationListView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 15/06/2025.
//

import SwiftUI

struct ConsultationListView: View {
    @Binding var consultations: [Consultation]
    let joinCall: (String) -> Void
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

    var body: some View {
        VStack {
            if consultations.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "video.slash.fill")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("No consultations found.")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(consultations) { consultation in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(consultation.type.displayName)
                                .font(.headline)
                            Text(consultation.date, style: .date)
                            Text(consultation.date, style: .time)
                        }

                        Spacer()

                        if let id = consultation.id {
                            Button("Join") { 
                                joinCall(id)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .navigationTitle("Video Consultations")
    }
}
