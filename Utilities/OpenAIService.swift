//
//  OpenAIService.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 07/07/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions

struct OpenAIService {
    static private let functions = Functions.functions()

    static func sendMessage(prompt: String, completion: @escaping (String?) -> Void) {
        let fullPrompt = """
        [UK Refugee Context]
        The user is a refugee in the United Kingdom seeking assistance. 
        Provide information relevant to UK services, laws, and support systems.
        Be empathetic and practical in your responses.

        User Question: \(prompt)
        """

        let data: [String: Any] = [
            "message": fullPrompt,
            "systemPrompt": "You are an expert advisor for refugees in the UK."
        ]

        functions.httpsCallable("chatWithGPT").call(data) { result, error in
            if let error = error {
                print("Error from chatWithGPT: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let data = result?.data as? [String: Any],
               let reply = data["reply"] as? String {
                completion(reply)
            } else {
                completion(nil)
            }
        }
    }
}
