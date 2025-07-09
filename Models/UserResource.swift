//
//  UserResource.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 04/07/2025.
//

import Foundation
import SwiftUI
import CoreLocation

struct UserResource: Identifiable {
    
    // MARK: - Initializer (convert from shared Resource model)
    init(from resource: Resource) {
        self.id = resource.id
        self.title = resource.title
        self.description = resource.description
        self.contactInfo = resource.contactInfo
        self.category = .generalSupport // or map from resource.category string
        self.isUrgent = resource.isUrgent == true
        self.iconName = resource.iconName
        self.urlString = resource.urlString
        self.accessibilityHint = resource.accessibilityHint
        self.type = resource.type ?? ResourceType.external
        self.location = resource.location
        self.languages = resource.languages
        self.distance = nil
    }

    // MARK: - Properties
    let id: String
    let title: String
    let description: String
    let contactInfo: String
    let category: UserResourceCategory
    let isUrgent: Bool
    let iconName: String?
    let urlString: String?
    let accessibilityHint: String?
    var type: ResourceType? = ResourceType.external
    let location: CLLocationCoordinate2D?
    
    var distance: Double?
    var languages: [String]? = []
}
