//
//  UKSampleData.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 04/07/2025.


import Foundation
import SwiftUI
import FirebaseFunctions
import CoreLocation

let ukSampleResources: [HelpResource] = [
    HelpResource(
        title: "Shelter Support",
        description: "Help with temporary accommodation.",
        iconName: "house.fill",
        urlString: "https://shelter.org.uk",
        type: ResourceType.web,
        isCritical: true,
        category: UserResourceCategory.housing,
        contactInfo: "0800 123 456",
        languages: ["English", "Arabic"],
        inAppDestination: nil,
        location: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278),
        distance: 0.0
    ),
    HelpResource(
        title: "Free Legal Help",
        description: "Legal advice for asylum cases.",
        iconName: "scales.of.justice",
        urlString: "https://legalhelp.org.uk",
        type: ResourceType.web,
        isCritical: false,
        category: UserResourceCategory.legal,
        contactInfo: "0800 789 012",
        languages: ["English", "Farsi", "Urdu"],
        inAppDestination: nil,
        location: CLLocationCoordinate2D(latitude: 51.509, longitude: -0.1357),
        distance: 0.0
    )
]
