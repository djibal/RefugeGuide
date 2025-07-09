//
//  RefugeeStatus.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 04/07/2025.
//

import Foundation

enum RefugeeStatus: String, Codable, CaseIterable {
    case refugee
    case asylumSeeker
    case existingAsylumSeeker
    case residencePermitHolder
    case seekingAsylum
    case grantedResidence
}
