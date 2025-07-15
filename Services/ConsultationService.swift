//
//  ConsultationService.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 25/07/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions
import FirebaseAuth
import SwiftUICore

class ConsultationService {
    static let shared = ConsultationService()

    private let functions = Functions.functions()

    func fetchConsultations() async throws -> [Consultation] {
        guard let user = Auth.auth().currentUser else {
            print("❌ Not authenticated, skipping Cloud Function call.")
            throw ConsultationError.networkError
        }

        print("📡 Calling Cloud Function: getConsultations for UID: \(user.uid)")

        do {
            let result = try await functions.httpsCallable("getConsultations").call()

            guard let dataArray = result.data as? [[String: Any]] else {
                print("❌ Unexpected format from Cloud Function result")
                throw ConsultationError.decodingError
            }

            let consultations = try dataArray.map { dict -> Consultation in
                let json = try JSONSerialization.data(withJSONObject: dict)
                return try JSONDecoder().decode(Consultation.self, from: json)
            }

            print("✅ Cloud Function returned \(consultations.count) consultations")
            return consultations
        } catch {
            print("❌ Cloud Function threw error: \(error.localizedDescription)")
            throw ConsultationError.networkError
        }
    }

    enum ConsultationError: Error {
        case networkError
        case decodingError
        case noConsultations
    }
}
