//
//  DocumentUploader.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/06/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DocumentUploader {
    static let shared = DocumentUploader()
    private let db = Firestore.firestore()

    func saveDocumentMetadata(
        fileName: String,
        downloadURL: URL,
        contentType: String,
        completion: @escaping (Error?) -> Void
    ) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }

        let documentData: [String: Any] = [
            "fileName": fileName,
            "downloadURL": downloadURL.absoluteString,
            "contentType": contentType,
            "timestamp": Timestamp(date: Date())
        ]

        db.collection("users").document(userId).collection("documents").addDocument(data: documentData) { error in
            completion(error)
        }
    }
}
