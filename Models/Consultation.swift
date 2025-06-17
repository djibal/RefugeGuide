//
//  Consultation.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 15/06/2025.
//

// Consultation.swift

import Foundation
import FirebaseFirestoreSwift

struct Consultation: Identifiable, Codable {
    @DocumentID var id: String?
    let date: Date
}
