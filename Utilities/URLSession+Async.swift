//
//  URLSession+Async.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 21/06/2025.
//

import Foundation

extension URLSession {
    func fetchAsylumCaseStatus(caseId: String) async throws -> AsylumCase {
        let urlString = "\(SecureConfig.asylumCaseEndpoint)\(caseId)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.addValue(SecureConfig.ukHomeOfficeAPIKey, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, _) = try await self.data(for: request)
        return try JSONDecoder().decode(AsylumCase.self, from: data)
    }
    
    func fetchLegalAidProviders(postcode: String) async throws -> [LegalProvider] {
        var components = URLComponents(string: SecureConfig.legalAidEndpoint)!
        components.queryItems = [URLQueryItem(name: "postcode", value: postcode)]
        
        var request = URLRequest(url: components.url!)
        request.addValue(SecureConfig.ukLocationServicesAPIKey, forHTTPHeaderField: "API-Key")
        
        let (data, _) = try await self.data(for: request)
        return try JSONDecoder().decode(LegalAidResponse.self, from: data).providers
    }
}

// Data Models
struct AsylumCase: Codable {
    let caseReference: String
    let status: CaseStatus
    let nextSteps: [String]
    let documentsRequired: [String]
    let appointmentDate: Date?
    
    enum CaseStatus: String, Codable {
        case submitted, interviewScheduled, decisionPending, granted, refused
    }
}

struct LegalAidResponse: Codable {
    let providers: [LegalProvider]
}

struct LegalProvider: Codable, Identifiable {
    let id: String
    let name: String
    let address: String
    let languages: [String]
    let distance: Double  // In miles
}
