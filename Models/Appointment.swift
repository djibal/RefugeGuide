//
//  Appointment.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//

import Foundation
import FirebaseFirestoreSwift

struct Appointment: Identifiable, Codable {
    @DocumentID var id: String?
    let type: String
    let notes: String
    let scheduledAt: Date
    let createdAt: Date
}
