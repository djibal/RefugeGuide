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

class ConsultationScheduleViewModel: ObservableObject {
    @Published var consultations: [Consultation] = []

    func fetchConsultations() {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }

        db.collection("users")
          .document(userID)
          .collection("consultations")
          .order(by: "date")
          .getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching consultations: \(error.localizedDescription)")
                return
            }

            if let documents = snapshot?.documents {
                self.consultations = documents.compactMap { doc in
                    try? doc.data(as: Consultation.self)
                }
            }
        }
    }
}
