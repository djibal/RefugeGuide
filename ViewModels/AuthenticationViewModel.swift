//
//  AuthenticationViewModel.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//

import SwiftUI
import FirebaseAuth
import LocalAuthentication

class AuthenticationViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var userType: RefugeeUserType?
    @Published var isBiometricLoginAvailable = false
    @Published var biometricError: String?

    private let biometricService = BiometricService()

    init() {
        self.currentUser = Auth.auth().currentUser
        checkBiometricAvailability()
    }

    private func checkBiometricAvailability() {
        isBiometricLoginAvailable = biometricService.canEvaluatePolicy()
    }

    func authenticateWithBiometrics(completion: @escaping (Bool) -> Void) {
        biometricService.authenticate { [weak self] result in
            switch result {
            case .success(let success):
                if success {
                    // Assuming successful biometric authentication means the user is logged in.
                    // You might want to fetch user data here.
                    self?.currentUser = Auth.auth().currentUser
                }
                completion(success)
            case .failure(let error):
                self?.biometricError = error.localizedDescription
                completion(false)
            }
        }
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
