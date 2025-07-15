//
//  Resource.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/07/2025.

import Foundation
import SwiftUI
import CoreLocation
import FirebaseFirestore

struct Resource: Identifiable, Codable {

    let id: String
    let title: String
    let description: String
    let contactInfo: String
    let category: UserResourceCategory
    let isUrgent: Bool
    let iconName: String
    let distance: Double
    let location: CLLocationCoordinate2D?
    let urlString: String?
    let languages: [String]
    let accessibilityHint: String?        // ✅ Included
    var type: ResourceType? = ResourceType.external

       // ✅ Included

    enum CodingKeys: String, CodingKey {
        case id, title, description, contactInfo, category, isUrgent, iconName, distance
        case urlString, languages, accessibilityHint, type
        case locationLat, locationLng
    }

    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        contactInfo: String,
        category: UserResourceCategory,
        isUrgent: Bool,
        iconName: String = "questionmark.circle",
        distance: Double = 0.0,
        location: CLLocationCoordinate2D? = nil,
        urlString: String? = nil,
        languages: [String] = [],
        accessibilityHint: String? = nil,
        type: ResourceType? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.contactInfo = contactInfo
        self.category = category
        self.isUrgent = isUrgent
        self.iconName = iconName
        self.distance = distance
        self.location = location
        self.urlString = urlString
        self.languages = languages
        self.accessibilityHint = accessibilityHint
        self.type = type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        contactInfo = try container.decode(String.self, forKey: .contactInfo)
        category = try container.decode(UserResourceCategory.self, forKey: .category)
        isUrgent = try container.decode(Bool.self, forKey: .isUrgent)
        iconName = try container.decode(String.self, forKey: .iconName)
        distance = try container.decode(Double.self, forKey: .distance)
        urlString = try container.decodeIfPresent(String.self, forKey: .urlString)
        languages = try container.decodeIfPresent([String].self, forKey: .languages) ?? []
        accessibilityHint = try container.decodeIfPresent(String.self, forKey: .accessibilityHint)
        type = try container.decodeIfPresent(ResourceType.self, forKey: .type)

        if let lat = try container.decodeIfPresent(CLLocationDegrees.self, forKey: .locationLat),
           let lng = try container.decodeIfPresent(CLLocationDegrees.self, forKey: .locationLng) {
            location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        } else {
            location = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(contactInfo, forKey: .contactInfo)
        try container.encode(category, forKey: .category)
        try container.encode(isUrgent, forKey: .isUrgent)
        try container.encode(iconName, forKey: .iconName)
        try container.encode(distance, forKey: .distance)
        try container.encodeIfPresent(urlString, forKey: .urlString)
        try container.encode(languages, forKey: .languages)
        try container.encodeIfPresent(accessibilityHint, forKey: .accessibilityHint)
        try container.encodeIfPresent(type, forKey: .type)

        if let location = location {
            try container.encode(location.latitude, forKey: .locationLat)
            try container.encode(location.longitude, forKey: .locationLng)
        }
    }
}
