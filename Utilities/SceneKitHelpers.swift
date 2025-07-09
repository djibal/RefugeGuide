// SceneKitHelpers.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 29/06/2025.

import ARKit
import SceneKit
import Foundation

extension SCNVector3 {
    static func positionFromBearing(_ bearing: Double, distance: Double) -> SCNVector3 {
        let angle = bearing.degreesToRadians
        return SCNVector3(
            x: Float(distance * sin(angle)),
            y: 0,
            z: Float(-distance * cos(angle)) // Adjust for scene orientation
        )
    }
}

extension Double {
    var degreesToRadians: Double { self * .pi / 180 }
}
