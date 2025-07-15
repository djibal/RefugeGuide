//
//  ConsultationScheduleViewModel.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 15/06/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import Combine
import SwiftUICore


class ConsultationScheduleViewModel: ObservableObject {
    @Published var consultations: [Consultation] = []
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var availableSlots: [Date] = []
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")
    
    private var listener: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    func fetchConsultations() {
        isLoading = true
        guard let userID = Auth.auth().currentUser?.uid else {
            errorMessage = "Authentication required"
            isLoading = false
            return
        }
        
        listener = Firestore.firestore().collection("users")
            .document(userID)
            .collection("consultations")
            .order(by: "date")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "Error fetching consultations: \(error.localizedDescription)"
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    self.consultations = []
                    return
                }
                
                self.consultations = documents.compactMap { doc in
                    try? doc.data(as: Consultation.self)
                }
            }
    }
    
    func scheduleConsultation(date: Date, type: ConsultationType, notes: String = "") {
        guard let userID = Auth.auth().currentUser?.uid else {
            errorMessage = "Authentication required"
            return
        }
        
        // Generate document reference with auto ID
        let documentRef = Firestore.firestore().collection("users")
            .document(userID)
            .collection("consultations")
            .document()
        
        var newConsultation = Consultation(
            id: documentRef.documentID,
            date: date,
            type: type,
            status: .scheduled,
            notes: notes
        )
        
        do {
            try documentRef.setData(from: newConsultation)
        } catch {
            errorMessage = "Failed to schedule: \(error.localizedDescription)"
        }
    }
    
    func cancelConsultation(_ consultation: Consultation) {
        guard let userID = Auth.auth().currentUser?.uid,
              let consultationID = consultation.id else {
            errorMessage = "Invalid consultation"
            return
        }
        
        Firestore.firestore().collection("users")
            .document(userID)
            .collection("consultations")
            .document(consultationID)
            .updateData([
                "status": ConsultationStatus.cancelled.rawValue,
                "cancelledAt": FieldValue.serverTimestamp()
            ]) { error in
                if let error = error {
                    self.errorMessage = "Cancellation failed: \(error.localizedDescription)"
                }
            }
    }
    
    func updateConsultationNotes(_ consultation: Consultation, notes: String) {
        guard let userID = Auth.auth().currentUser?.uid,
              let consultationID = consultation.id else {
            return
        }
        
        Firestore.firestore().collection("users")
            .document(userID)
            .collection("consultations")
            .document(consultationID)
            .updateData(["notes": notes]) { error in
                if let error = error {
                    print("Note update failed: \(error.localizedDescription)")
                }
            }
    }
    
    func fetchAvailableSlots(specialistID: String, date: Date) {
        // Implementation to fetch available time slots from backend
    }
    
    deinit {
        listener?.remove()
    }
}
