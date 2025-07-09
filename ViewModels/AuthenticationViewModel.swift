//
//  AuthenticationViewModel.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//

import SwiftUI
import FirebaseAuth

class AuthenticationViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var userType: RefugeeUserType? // ✅ Link to your renamed enum

    init() {
        self.currentUser = Auth.auth().currentUser
    }

    func signOut() throws {
        try Auth.auth().signOut()
        currentUser = nil
        userType = nil
    }

    func deleteAccount(completion: @escaping (Error?) -> Void) {
        Auth.auth().currentUser?.delete(completion: completion)
    }
}
