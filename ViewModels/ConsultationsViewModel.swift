//
//  ConsultationsViewModel.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 09/08/2025.
//

import Foundation
import FirebaseFunctions
import FirebaseAuth

@MainActor
final class ConsultationsViewModel: ObservableObject {
    @Published var consultations: [Consultation] = []
    @Published var errorMessage: String = ""

    func loadConsultations() async {
        guard Auth.auth().currentUser != nil else {
            errorMessage = "User not authenticated"
            return
        }

        do {
            let result = try await Functions.functions()
                .httpsCallable("getConsultations")
                .call([String: String]())   // empty, but Sendable

            // Debug log raw payload (optional)
            if let dict = result.data as? [String: Any] {
                print("getConsultations raw:", dict)
            }

            let data = try JSONSerialization.data(withJSONObject: result.data, options: [])
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970

            struct Payload: Codable {
                let items: [Consultation]
            }

            let payload = try decoder.decode(Payload.self, from: data)
            self.consultations = payload.items
            self.errorMessage = ""

        } catch {
            print("❌ getConsultations decode error:", error)
            self.errorMessage = "networkError"
        }
    }
}
