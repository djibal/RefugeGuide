//
//  URLSession+Async.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 21/06/2025.
//

import Foundation

extension URLSession {
    func asyncData(for request: URLRequest) async throws -> (Data, URLResponse) {
        if #available(iOS 15.0, macOS 12.0, *) {
            return try await self.data(for: request, delegate: nil)
        } else {
            return try await withCheckedThrowingContinuation { continuation in
                let task = self.dataTask(with: request) { data, response, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let data = data, let response = response {
                        continuation.resume(returning: (data, response))
                    } else {
                        continuation.resume(throwing: URLError(.badServerResponse))
                    }
                }
                task.resume()
            }
        }
    }
}
