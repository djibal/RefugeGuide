
import Foundation
import LocalAuthentication

class BiometricService {
    
    private let context = LAContext()
    private let policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
    private var error: NSError?

    enum BiometricType {
        case none
        case touchID
        case faceID
    }

    func biometricType() -> BiometricType {
        guard context.canEvaluatePolicy(policy, error: &error) else {
            return .none
        }
        
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        @unknown default:
            return .none
        }
    }
    
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(policy, error: &error)
    }
    
    func authenticate(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard canEvaluatePolicy() else {
            completion(.failure(error ?? LAError(.biometryNotAvailable)))
            return
        }
        
        let reason = "Log in to your account"
        
        context.evaluatePolicy(policy, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                if success {
                    completion(.success(true))
                } else {
                    completion(.failure(error ?? LAError(.userCancel)))
                }
            }
        }
    }
}
