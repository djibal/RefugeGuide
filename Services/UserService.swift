//
//  UserService.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//
import SwiftUI
import Foundation
import FirebaseFirestore


enum LegalStatus: String, Codable {
    case refugee, asylumSeeker, humanitarianProtection, discretionaryLeave, undocumented

    var displayName: String {
        switch self {
        case .refugee: return "Refugee"
        case .asylumSeeker: return "Asylum Seeker"
        case .humanitarianProtection: return "Humanitarian Protection"
        case .discretionaryLeave: return "Discretionary Leave"
        case .undocumented: return "Undocumented"
        }
    }

    var color: Color {
        switch self {
        case .refugee: return .green
        case .asylumSeeker: return .orange
        case .humanitarianProtection: return .blue
        case .discretionaryLeave: return .purple
        case .undocumented: return .red
        }
    }
}

class UserService {
    static func fetchUserDetails(userId: String) async throws -> UserDetails {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        return try snapshot.data(as: UserDetails.self)
    }
}
