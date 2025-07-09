//
//  CaseStatusView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct CaseStatusView: View {
    @State private var currentStep = "screening"
    @State private var isLoading = true
    @State private var errorMessage: String?

    let steps = [
        "screening": "Screening Interview",
        "awaitingDocuments": "Awaiting Documents",
        "interviewScheduled": "Main Interview Scheduled",
        "decisionPending": "Decision Pending",
        "approved": "Approved",
        "rejected": "Rejected"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if isLoading {
                ProgressView("Loading Case Status...")
            } else {
                Text("Current Case Step:")
                    .font(.headline)

                if let status = steps[currentStep] {
                    Text(status)
                        .font(.title2.bold())
                        .foregroundColor(.blue)
                } else {
                    Text("Unknown")
                }

                Divider()

                ForEach(steps.sorted(by: { $0.key < $1.key }), id: \.key) { key, title in
                    HStack {
                        Image(systemName: key == currentStep ? "circle.fill" : "circle")
                            .foregroundColor(key == currentStep ? .blue : .gray)
                        Text(title)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Case Status")
        .onAppear(perform: fetchStatus)
        .alert("Error", isPresented: .constant(errorMessage != nil), actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text(errorMessage ?? "")
        })
    }

    private func fetchStatus() {
        guard let uid = Auth.auth().currentUser?.uid else {
            errorMessage = "User not logged in."
            return
        }

        let docRef = Firestore.firestore().collection("users").document(uid)
        docRef.getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to load: \(error.localizedDescription)"
                self.isLoading = false
                return
            }

            if let status = snapshot?.get("caseStatus") as? String {
                self.currentStep = status
            } else {
                self.currentStep = "screening"
            }

            self.isLoading = false
        }
    }
}
