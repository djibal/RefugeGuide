//
//  AgoraTokenService.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 25/07/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions
import AgoraRtcKit
import SwiftUICore

class AgoraTokenService {
    private let functions = Functions.functions()

    func getToken(forChannel channelName: String, completion: @escaping (Result<String, Error>) -> Void) {
        let data: [String: Any] = [
            "channelName": channelName,
            "uid": 0, // Let Agora assign UID
            "role": "publisher"
        ]

        functions.httpsCallable("generateAgoraToken").call(data) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let tokenData = result?.data as? [String: Any],
               let token = tokenData["token"] as? String {
                completion(.success(token))
            } else {
                completion(.failure(NSError(domain: "AgoraToken", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid token response."])))
            }
        }
    }
}
