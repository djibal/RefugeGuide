//
//  CaseStatusView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SwiftUICore

struct CaseStatusView: View {
    @State private var currentStep = "screening"
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    
    let primaryColor = Color(hex: "#0D3B66")  // Rich blue
    let accentColor = Color(hex: "#F95738")   // Bright coral-red
    let cardColor = Color(hex: "#FFFFFF")     // White
    let backgroundColor = Color(hex: "#F5F9FF") // Soft blue-white
    let textPrimary = Color(hex: "#1A1A1A")   // Neutral dark
    let textSecondary = Color(hex: "#555555") // Medium gray
    
    
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
        isLoading = true
        errorMessage = nil
        
        guard let uid = Auth.auth().currentUser?.uid else {
            errorMessage = "User not logged in."
            isLoading = false
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(uid)
        userRef.getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to load: \(error.localizedDescription)"
                self.isLoading = false
                return
            }
            
            guard let referenceNumber = snapshot?.get("referenceNumber") as? String else {
                self.errorMessage = "No reference number found."
                self.isLoading = false
                return
            }
            
            let service = AsylumCaseService()
            service.fetchStatus(referenceNumber: referenceNumber) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let newStatus):
                        self.currentStep = newStatus
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                    
                    self.isLoading = false
                }
            }
        }
    }
}
