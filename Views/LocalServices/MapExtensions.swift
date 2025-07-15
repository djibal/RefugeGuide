//
//  MapExtensions.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 17/06/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions
import MapKit

extension Sequence where Element == CLLocationCoordinate2D {
    var centerPoint: CLLocationCoordinate2D {
        let count = Double(self.underestimatedCount)
        let sum = reduce((latitude: 0.0, longitude: 0.0)) {
            ($0.latitude + $1.latitude, $0.longitude + $1.longitude)
        }
        return CLLocationCoordinate2D(latitude: sum.latitude / count, longitude: sum.longitude / count)
    }

    var span: (latitudeDelta: Double, longitudeDelta: Double) {
        let latitudes = map(\.latitude)
        let longitudes = map(\.longitude)
        guard let minLat = latitudes.min(), let maxLat = latitudes.max(),
              let minLon = longitudes.min(), let maxLon = longitudes.max() else {
            return (0.1, 0.1)
        }
        return (
            latitudeDelta: Swift.max(0.05, (maxLat - minLat) * 1.2),
            longitudeDelta: Swift.max(0.05, (maxLon - minLon) * 1.2)
        )
    }
}
