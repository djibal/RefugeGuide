//
//  ProfileViewModel.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 15/07/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var userDetails: UserDetails?
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = true
    
    func loadUserDetails() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            self.errorMessage = "User not logged in."
            self.isLoading = false
            return
        }
        
        do {
            let snapshot = try await Firestore.firestore()
                .collection("users")
                .document(userId)
                .getDocument()
            
            guard let data = try? snapshot.data(as: UserDetails.self) else {
                self.errorMessage = "User details missing or malformed."
                self.isLoading = false
                return
            }
            
            self.userDetails = data
            self.isLoading = false
        } catch {
            self.errorMessage = "Failed to load user details: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
}
