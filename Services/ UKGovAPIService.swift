//
//   UKGovAPIService.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 30/06/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions

// Implement rate limiting
class UKGovAPIService {
    private let throttleQueue = DispatchQueue(label: "ukgov.api.throttle")
    private var lastRequestTime: Date = .distantPast
    
    func makeRequest(_ request: URLRequest) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            throttleQueue.async {
                // Ensure 100ms between requests
                let minInterval: TimeInterval = 0.1
                let elapsed = Date().timeIntervalSince(self.lastRequestTime)
                let delay = max(0, minInterval - elapsed)
                
                DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                    self.lastRequestTime = Date()
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        // Handle response
                    }.resume()
                }
            }
        }
    }
}
