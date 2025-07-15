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
