//
//  HelpResource.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 16/06/2025.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation
import SwiftUI
import FirebaseFunctions

struct HelpResource: Identifiable, Codable {
    @DocumentID var id: String?
    let title: String
    let description: String
    let iconName: String
    let urlString: String?
    let type: ResourceType
    let isCritical: Bool
    let category: UserResourceCategory
    let contactInfo: String
    let languages: [String]
    let inAppDestination: String?
    
    // Optional fields copied from UserResource
    var location: CLLocationCoordinate2D?
    var distance: Double?

    var accessibilityHint: String {
        type == .inApp ? "Opens in app" : "Opens external link"
    }

    var actionIcon: String {
        switch type {
        case .phone: return "phone.fill"
        case .email: return "envelope.fill"
        case .web: return "globe"
        case .inApp: return "arrow.right"
        default: return "questionmark.circle"
        }
    }

    var isUrgent: Bool {
        return isCritical
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case iconName
        case urlString
        case type
        case isCritical
        case category
        case contactInfo
        case languages
        case inAppDestination
        case locationLatitude
        case locationLongitude
        case distance
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.iconName = try container.decode(String.self, forKey: .iconName)
        self.urlString = try container.decodeIfPresent(String.self, forKey: .urlString)
        self.type = try container.decode(ResourceType.self, forKey: .type)
        self.isCritical = try container.decode(Bool.self, forKey: .isCritical)
        self.category = try container.decode(UserResourceCategory.self, forKey: .category)
        self.contactInfo = try container.decode(String.self, forKey: .contactInfo)
        self.languages = try container.decode([String].self, forKey: .languages)
        self.inAppDestination = try container.decodeIfPresent(String.self, forKey: .inAppDestination)
        self.distance = try container.decodeIfPresent(Double.self, forKey: .distance)

        if let lat = try container.decodeIfPresent(CLLocationDegrees.self, forKey: .locationLatitude),
           let lon = try container.decodeIfPresent(CLLocationDegrees.self, forKey: .locationLongitude) {
            self.location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        } else {
            self.location = nil
        }
    }

    init(
        id: String? = nil,
        title: String,
        description: String,
        iconName: String,
        urlString: String?,
        type: ResourceType,
        isCritical: Bool,
        category: UserResourceCategory,
        contactInfo: String,
        languages: [String],
        inAppDestination: String?,
        location: CLLocationCoordinate2D? = nil,
        distance: Double? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.iconName = iconName
        self.urlString = urlString
        self.type = type
        self.isCritical = isCritical
        self.category = category
        self.contactInfo = contactInfo
        self.languages = languages
        self.inAppDestination = inAppDestination
        self.location = location
        self.distance = distance
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(iconName, forKey: .iconName)
        try container.encodeIfPresent(urlString, forKey: .urlString)
        try container.encode(type, forKey: .type)
        try container.encode(isCritical, forKey: .isCritical)
        try container.encode(category, forKey: .category)
        try container.encode(contactInfo, forKey: .contactInfo)
        try container.encode(languages, forKey: .languages)
        try container.encodeIfPresent(inAppDestination, forKey: .inAppDestination)
        try container.encodeIfPresent(distance, forKey: .distance)

        if let coordinate = location {
            try container.encode(coordinate.latitude, forKey: .locationLatitude)
            try container.encode(coordinate.longitude, forKey: .locationLongitude)
        }
    }
}


