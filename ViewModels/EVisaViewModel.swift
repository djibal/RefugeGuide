//
//  EVisaViewModel.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/08/2025.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import Combine
import SwiftUICore
import FirebaseAuth

final class EVisaViewModel: ObservableObject {
    @Published var eVisaData: EVisaData?
    @Published var isLoading = false
    
    let primaryColor = Color(hex: "#0D3B66")  // Rich blue
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")
    
    @Published var errorMessage = ""
    
    let statusOptions = [
        "Application Received",
        "Interview Scheduled",
        "Decision Pending",
        "Visa Issued"
    ]
    
    init() {
        loadEVisaData()
    }
    
    func loadEVisaData() {
        guard let uid = Auth.auth().currentUser?.uid else {
            errorMessage = "User not authenticated"
            return
        }
        
        isLoading = true
        let docRef = Firestore.firestore().collection("evisa").document(uid)
        
        docRef.getDocument { [weak self] snapshot, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard let data = snapshot?.data(), error == nil else {
                    self?.errorMessage = error?.localizedDescription ?? "No eVisa data found"
                    return
                }
                
                guard let expiryTimestamp = data["expiryDate"] as? Timestamp else {
                    self?.errorMessage = "Invalid expiry date"
                    return
                }
                
                self?.eVisaData = EVisaData(
                    userId: uid,
                    fullName: data["fullName"] as? String ?? "",
                    visaType: data["visaType"] as? String ?? "",
                    expiryDate: expiryTimestamp,
                    currentStatus: data["currentStatus"] as? String ?? "",
                    shareCode: data["shareCode"] as? String ?? "",
                    issuingCountry: data["issuingCountry"] as? String ?? "",
                    issuingAuthority: data["issuingAuthority"] as? String ?? ""
                )
            }
        }
    }
    
    @MainActor
    func saveEVisaData(data: EVisaData) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        isLoading = true
        defer { isLoading = false }
        
        let payload: [String: Any] = [
            "fullName": data.fullName,
            "visaType": data.visaType,
            "expiryDate": data.expiryDate,          // Timestamp is OK
            "currentStatus": data.currentStatus,    // must be one of the allowed values
            "shareCode": data.shareCode,            // <= 20 chars
            "issuingCountry": data.issuingCountry,
            "issuingAuthority": data.issuingAuthority,
            // "statusItems": data.statusItems,      // optional: include if you add a timeline
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        do {
            try await Firestore.firestore()
                .collection("evisa")
                .document(uid)
                .setData(payload, merge: true)      // merge so we don’t wipe future fields
            self.eVisaData = data
            self.errorMessage = ""
        } catch {
            self.errorMessage = error.localizedDescription
            throw error
        }
    }
}
