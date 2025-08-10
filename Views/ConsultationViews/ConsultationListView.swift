//
//  ConsultationListView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 15/06/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions
import FirebaseAuth
import SwiftUI

struct ConsultationListView: View {
    @Binding var consultations: [Consultation]
    let joinCall: (String) -> Void

    // ✅ Explicit initializer so the call in the wrapper always matches
    init(consultations: Binding<[Consultation]>, joinCall: @escaping (String) -> Void) {
        self._consultations = consultations
        self.joinCall = joinCall
    }

    var body: some View {
        if consultations.isEmpty {
            VStack(spacing: 12) {
                Image(systemName: "video.slash.fill")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                Text("No consultations found.")
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List(consultations) { c in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(c.type.displayName).font(.headline)
                        Text(c.date, style: .date)
                        Text(c.date, style: .time)
                    }
                    Spacer()
                    if let id = c.id {
                        Button("Join") { joinCall(id) }
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
    }
}
