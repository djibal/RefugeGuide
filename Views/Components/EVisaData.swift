//
//  EVisaData.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 06/08/2025.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import Combine
import FirebaseAuth
import Combine


struct EVisaData: Identifiable {
    var id: String { userId }
    let userId: String
    let fullName: String
    let visaType: String
    let expiryDate: Timestamp
    let currentStatus: String
    let shareCode: String
    let issuingCountry: String
    let issuingAuthority: String
    
    private let primaryColor = Color(red: 0.07, green: 0.36, blue: 0.65)   // Deep UK blue
    private let accentColor = Color(red: 0.94, green: 0.35, blue: 0.15)    // UK orange
    private let backgroundColor = Color(red: 0.96, green: 0.96, blue: 0.98)

    var statusItems: [String] {
        ["Application Received", "Interview Scheduled", "Decision Pending", "Visa Issued"]
            .prefix { $0 != currentStatus }
            .appending(currentStatus)
    }
}

extension Array {
    func appending(_ element: Element) -> [Element] {
        var copy = self
        copy.append(element)
        return copy
    }
}
