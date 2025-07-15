//
//  Service.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//

import Foundation
import CoreLocation
import SwiftUI
import FirebaseFunctions

struct Service: Identifiable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let category: String
    var distance: Double? = nil  // ✅ Computed at runtime for sorting
}
