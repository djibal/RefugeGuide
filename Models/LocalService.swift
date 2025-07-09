//
//  LocalService.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 17/06/2025.

import Foundation
import CoreLocation
import MapKit
import FirebaseFirestoreSwift 


struct LocalService: Identifiable, Codable, Hashable {
    @DocumentID var id: String?  // ✅ Firestore ID
    var distance: Double? = nil  // ✅ Only declare ONCE

    var distanceString: String {
        if let userLocation = CLLocationManager().location {
            return distance(from: userLocation)
        } else {
            return NSLocalizedString("Distance Unknown", comment: "")
        }
    }


    let name: String
    let category: String
    let description: String
    let rating: Double?
    let discount: Int?
    let phone: String?
    let website: String?
    let address: String
    let latitude: Double
    let longitude: Double
    let openingHours: String?
    let isRefugeeFriendly: Bool?
    let imageUrl: String?  // ✅ NEW

    

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
    }

    func distance(from location: CLLocation?) -> String {
        
        guard let location = location else { return "—" }
        let serviceLocation = CLLocation(latitude: latitude, longitude: longitude)
        let distance = serviceLocation.distance(from: location)

        if distance < 1000 {
            return String(format: "%.0f m", distance)
        } else {
            return String(format: "%.1f km", distance / 1000)
        }
    }

    init(
        id: String,
        name: String,
        category: String,
        description: String,
        rating: Double? = nil,
        discount: Int? = nil,
        phone: String? = nil,
        website: String? = nil,
        address: String,
        latitude: Double,
        longitude: Double,
        openingHours: String? = nil,
        isRefugeeFriendly: Bool? = nil,
        imageUrl: String? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.description = description
        self.rating = rating
        self.discount = discount
        self.phone = phone
        self.website = website
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.openingHours = openingHours
        self.isRefugeeFriendly = isRefugeeFriendly
        self.imageUrl = imageUrl
    }

    // MARK: Sample Preview Data
    static var sampleServices: [LocalService] = [
        LocalService(
            id: "1",
            name: "Community Legal Center",
            category: "Legal",
            description: "Provides free legal consultations for immigrants and refugees. Specializes in asylum cases and family reunification.",
            rating: 4.8,
            discount: 20,
            phone: "+1234567890",
            website: "https://communitylegal.example",
            address: "123 Justice St, City Center",
            latitude: 51.5074,
            longitude: -0.1278,
            openingHours: "Mon–Fri: 9am–5pm",
            isRefugeeFriendly: true,
            imageUrl: "https://example.com/legal.png"
        ),
        LocalService(
            id: "2",
            name: "Global Food Market",
            category: "Food",
            description: "Specialty market with foods from around the world. Offers discounts for refugee families.",
            rating: 4.5,
            discount: 15,
            phone: "+1987654321",
            website: "https://globalfood.example",
            address: "456 Market Ave, Downtown",
            latitude: 51.5080,
            longitude: -0.1285,
            openingHours: "Daily: 8am–8pm",
            isRefugeeFriendly: true,
            imageUrl: "https://example.com/food.png"
        ),
        LocalService(
            id: "3",
            name: "Health First Clinic",
            category: "Medical",
            description: "Multilingual medical staff offering free checkups for refugees and discounted prescriptions.",
            rating: 4.9,
            discount: 30,
            phone: "+1122334455",
            website: "https://healthfirst.example",
            address: "789 Wellness Blvd, North District",
            latitude: 51.5092,
            longitude: -0.1263,
            openingHours: "Mon–Sat: 8am–6pm",
            isRefugeeFriendly: true,
            imageUrl: "https://example.com/medical.png"
        )
    ]
}
