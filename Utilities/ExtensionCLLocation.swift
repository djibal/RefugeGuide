//
//  ExtensionCLLocation.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 29/06/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions
import CoreLocation

extension CLLocation {
    func bearing(to destination: CLLocation) -> Double {
        let lat1 = self.coordinate.latitude.toRadians()
        let lon1 = self.coordinate.longitude.toRadians()
        let lat2 = destination.coordinate.latitude.toRadians()
        let lon2 = destination.coordinate.longitude.toRadians()
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansBearing.toDegrees()
    }
    
    func compassDirection(to destination: CLLocation) -> String {
        let bearing = self.bearing(to: destination)
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let index = Int((bearing + 22.5) / 45.0) % 8
        return directions[index]
    }
}

extension Double {
    func toRadians() -> Double {
        return self * .pi / 180
    }
    
    func toDegrees() -> Double {
        return (self * 180 / .pi).truncatingRemainder(dividingBy: 360)
    }
}
