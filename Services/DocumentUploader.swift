//
//  DocumentUploader.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/06/2025.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUICore

class DocumentUploader {
    static let shared = DocumentUploader()
    private let db = Firestore.firestore()
    
    func saveDocumentMetadata(
        fileName: String,
        downloadURL: URL,
        contentType: String,
        documentType: UKDocumentType,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError.authRequired))
            return
        }
        
        let documentData: [String: Any] = [
            "fileName": fileName,
            "downloadURL": downloadURL.absoluteString,
            "contentType": contentType,
            "documentType": documentType.rawValue,
            "timestamp": Timestamp(date: Date()),
            "status": "pending_verification"
        ]
        
        let docRef = db.collection("users").document(userId).collection("documents").document()
        
        docRef.setData(documentData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(docRef.documentID))
            }
        }
    }
    
    func updateDocumentStatus(documentId: String, status: UKVerificationStatus, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(NSError.authRequired)
            return
        }
        
        db.collection("users").document(userId).collection("documents").document(documentId)
            .updateData(["status": status.rawValue]) { error in
                completion(error)
            }
    }
}

enum DocumentType: String, CaseIterable {
    case passport = "Passport"
    case birthCertificate = "Birth Certificate"
    case proofOfAddress = "Proof of Address"
    case nassCard = "NASS Card"
    case biometricResidence = "BRP"
    case asylumApplication = "Asylum Application"
    case other = "Other"
}

enum UKVerificationStatus: String {
    case pending = "pending_verification"
    case verified = "verified"
    case rejected = "rejected"
    case reviewNeeded = "review_needed"
}

extension NSError {
    static var authRequired: NSError {
        NSError(domain: "auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authentication required"])
    }
}
