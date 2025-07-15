//
//  AsylumCaseService.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 23/07/2025.
//import Foundation
import SwiftUI
import FirebaseFunctions
import AgoraRtcKit
import SwiftUICore

class AsylumCaseService {
    private let functions = Functions.functions()

    func fetchStatus(referenceNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        functions.httpsCallable("getAsylumCaseStatus").call(["referenceNumber": referenceNumber]) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = result?.data as? [String: Any],
               let status = data["status"] as? String {
                completion(.success(status))
            } else {
                completion(.failure(NSError(domain: "AsylumStatus", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
            }
        }
    }
}
