//
//  AuthManager.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 12/06/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthManager {
    static let shared = AuthManager()
    private let db = Firestore.firestore()

    func storeUserProfile(user: User, provider: String) {
        let userRef = db.collection("users").document(user.uid)

        userRef.getDocument { document, error in
            if let document = document, document.exists {
                print("✅ User already exists in Firestore.")
                return
            }

            let userData: [String: Any] = [
                "uid": user.uid,
                "email": user.email ?? "",
                "displayName": user.displayName ?? "",
                "provider": provider,
                "createdAt": FieldValue.serverTimestamp()
            ]

            userRef.setData(userData) { error in
                if let error = error {
                    print("❌ Failed to save user: \(error.localizedDescription)")
                } else {
                    print("✅ User profile saved to Firestore.")
                }
            }
        }
    }
}
