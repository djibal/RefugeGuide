//
//  ConsultationListWrapper.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 20/07/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore
import FirebaseAuth
import FirebaseAuth

struct ConsultationListWrapper: View {
    @State private var consultations: [Consultation] = []
    @State private var selectedConsultation: Consultation?
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Video Consultations")
                // iOS 16 friendly detail presentation
                .sheet(item: $selectedConsultation) { consultation in
                    VideoConsultationView(consultation: consultation)
                }
                .task { await waitAndLoadConsultations() }
        }
    }

    @ViewBuilder
    private var content: some View {
        if isLoading {
            ProgressView("Loading consultations...")
        } else if let errorMessage {
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.orange)
                Text("Error").font(.headline)
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            .padding()
        } else {
            // ✅ Make sure your ConsultationListView has this signature:
            // struct ConsultationListView: View {
            //   @Binding var consultations: [Consultation]
            //   let joinCall: (String) -> Void
            //   ...
            // }
            ConsultationListView(
                consultations: $consultations,
                joinCall: { id in
                    if let c = consultations.first(where: { $0.id == id }) {
                        selectedConsultation = c
                    }
                }
            )
        }
    }

    private func waitAndLoadConsultations() async {
        var attempt = 0
        while Auth.auth().currentUser == nil && attempt < 20 {
            try? await Task.sleep(nanoseconds: 200_000_000) // 0.2s
            attempt += 1
        }
        guard Auth.auth().currentUser != nil else {
            errorMessage = "You must be signed in to view consultations."
            isLoading = false
            return
        }
        await loadConsultations()
    }

    private func loadConsultations() async {
        do {
            let fetched = try await ConsultationService.shared.fetchConsultations()
            consultations = fetched
            errorMessage = nil
        } catch {
            errorMessage = "Failed to load consultations. Please try again later."
            print("❌ Error loading consultations:", error)
        }
        isLoading = false
    }
}
