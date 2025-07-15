////
////  FirebaseManager.swift
////  RefugeGuide
////
////  Created by Djibal Ramazani on 11/06/2025.
////

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SwiftUICore

class FirebaseManager {
    static let shared = FirebaseManager()
    let auth: Auth
    let firestore: Firestore
    let storage: Storage

    private init() {
        FirebaseApp.configure()
        auth = Auth.auth()
        firestore = Firestore.firestore()
        storage = Storage.storage()
        
        // Enable offline persistence
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        firestore.settings = settings
    }
    
    // User management
    func currentUser() -> User? {
        return auth.currentUser
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    // Firestore collections
    func userDocument() -> DocumentReference? {
        guard let uid = auth.currentUser?.uid else { return nil }
        return firestore.collection("users").document(uid)
    }
    
    func documentsCollection() -> CollectionReference? {
        return userDocument()?.collection("documents")
    }
    
    // UK-specific resources
    func fetchUKResources(completion: @escaping ([UKResource]) -> Void) {
        firestore.collection("uk_resources").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching resources: \(error?.localizedDescription ?? "Unknown")")
                return
            }
            
            let resources = documents.compactMap { doc -> UKResource? in
                try? doc.data(as: UKResource.self)
            }
            completion(resources)
        }
    }
}

struct UKResource: Codable, Identifiable {
    @DocumentID var id: String?
    let title: String
    let description: String
    let category: ResourceCategory
    let url: String
    let phone: String?
    let location: GeoPoint?
    
    enum ResourceCategory: String, Codable {
        case legal = "Legal Aid"
        case housing = "Housing"
        case healthcare = "Healthcare"
        case education = "Education"
        case employment = "Employment"
        case financial = "Financial Support"
    }
}
