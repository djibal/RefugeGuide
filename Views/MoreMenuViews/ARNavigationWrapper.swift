//
//  ARNavigationWrapper.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 20/07/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore
import CoreLocation

struct ARNavigationWrapper: View {
    
    
    var body: some View {
        ARNavigationView(
            destinationCoordinate: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278), // London default
            destinationName: "Home Office"
        )
    }
}
