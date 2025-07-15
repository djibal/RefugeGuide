//
//   UKGovAPIService.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 30/06/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions

// Implement rate limiting and caching
class UKGovAPIService {
    private let throttleQueue = DispatchQueue(label: "ukgov.api.throttle")
    private var lastRequestTime: Date = .distantPast
    private let cache = URLCache.shared

    func makeRequest(_ request: URLRequest) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            throttleQueue.async {
                // Check cache first
                if let cachedResponse = self.cache.cachedResponse(for: request) {
                    continuation.resume(returning: cachedResponse.data)
                    return
                }

                // Ensure 100ms between requests
                let minInterval: TimeInterval = 0.1
                let elapsed = Date().timeIntervalSince(self.lastRequestTime)
                let delay = max(0, minInterval - elapsed)

                DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                    self.lastRequestTime = Date()
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let data = data, let response = response {
                            let cachedResponse = CachedURLResponse(response: response, data: data)
                            self.cache.storeCachedResponse(cachedResponse, for: request)
                            continuation.resume(returning: data)
                        } else if let error = error {
                            continuation.resume(throwing: error)
                        }
                    }.resume()
                }
            }
        }
    }
}
