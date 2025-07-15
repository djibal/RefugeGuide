//
//  MappingUtils.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 04/07/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions

func convertToUserType(from refugeeType: RefugeeUserType) -> RefugeeUserType {
    switch refugeeType {
    case .refugee:
        return .refugee
    case .existingAsylumSeeker:
        return .existingAsylumSeeker
    case .asylumSeeker, .newAsylumSeeker, .seekingAsylum:
        return .asylumSeeker
    case .residencePermitHolder, .grantedResidence:
        return .unknown
    case .unknown:
        return .unknown
    }
}

func convertToRefugeeUserType(from userType: RefugeeUserType) -> RefugeeUserType {
    switch userType {
    case .refugee:
        return .refugee
    case .asylumSeeker:
        return .asylumSeeker
    case .existingAsylumSeeker:
        return .existingAsylumSeeker
    case .grantedResidence:
        return .grantedResidence
    case .residencePermitHolder:
        return .residencePermitHolder
    case .newAsylumSeeker, .seekingAsylum:
        return .asylumSeeker
    case .unknown:
        return .asylumSeeker // fallback
    }
}

func convertToRefugeeStatus(from refugeeType: RefugeeUserType) -> RefugeeStatus {
    switch refugeeType {
    case .refugee:
        return .refugee
    case .existingAsylumSeeker:
        return .existingAsylumSeeker
    case .asylumSeeker, .newAsylumSeeker, .seekingAsylum:
        return .asylumSeeker
    case .residencePermitHolder, .grantedResidence:
        return .residencePermitHolder
    case .unknown:
        return .seekingAsylum // fallback status
    }
}

