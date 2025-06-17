//
//  ervicesViewModel.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 17/06/2025.
//

import Foundation
import FirebaseFirestore

class ServicesViewModel: ObservableObject {
    @Published var services: [LocalService] = []
    private var listener: ListenerRegistration?

    func fetchServices() {
        let db = Firestore.firestore()
        listener = db.collection("services")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching services: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                self.services = documents.compactMap { document in
                    LocalService(document: document.data())
                }
            }
    }

    deinit {
        listener?.remove()
    }
}
