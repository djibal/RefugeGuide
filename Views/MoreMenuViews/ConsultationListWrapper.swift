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

struct ConsultationListWrapper: View {
    @State private var consultations: [Consultation] = []
    @State private var selectedConsultation: Consultation?
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Loading consultations...")
                } else if let errorMessage = errorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.orange)
                        Text("Error")
                            .font(.headline)
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    ConsultationListView(
                        consultations: $consultations,
                        joinCall: { id in
                            selectedConsultation = consultations.first { $0.id == id }
                        }
                    )
                }
            }
            .navigationDestination(
                isPresented: Binding(
                    get: { selectedConsultation != nil },
                    set: { if !$0 { selectedConsultation = nil } }
                )
            ) {
                if let consultation = selectedConsultation {
                    VideoConsultationView(consultation: consultation)
                }
            }
            .task {
                await waitAndLoadConsultations()
            }
        }
    }

    private func waitAndLoadConsultations() async {
        print("🔄 Waiting for Firebase authentication...")
        var attempt = 0
        while Auth.auth().currentUser == nil && attempt < 20 {
            try? await Task.sleep(nanoseconds: 200_000_000) // 0.2s
            attempt += 1
        }

        if Auth.auth().currentUser == nil {
            print("❌ User not authenticated after waiting")
            errorMessage = "You must be signed in to view consultations."
            isLoading = false
            return
        }

        print("✅ Firebase user UID:", Auth.auth().currentUser?.uid ?? "unknown")
        await loadConsultations()
    }

    private func loadConsultations() async {
        do {
            let fetchedConsultations = try await ConsultationService.shared.fetchConsultations()
            consultations = fetchedConsultations
            errorMessage = nil
            if fetchedConsultations.isEmpty {
                print("ℹ️ No consultations found.")
            } else {
                print("✅ Loaded \(fetchedConsultations.count) consultations.")
            }
        } catch {
            errorMessage = "Failed to load consultations. Please try again later."
            print("❌ Error loading consultations: \(error)")
        }
        isLoading = false
    }
}
