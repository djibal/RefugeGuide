//
//  ConsultationListView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 15/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions

struct ConsultationListView: View {
    @Binding var consultations: [Consultation]
    let joinCall: (String) -> Void
    
    var body: some View {
        List(consultations) { consultation in
            HStack {
                VStack(alignment: .leading) {
                    Text("Consultation")
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
            .navigationTitle("Video Consultations")
        }
    }
}
