//
//  ARNavigationViewModel.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 29/06/2025.
//
import SwiftUI
import ARKit
import SceneKit
import CoreLocation

class ARNavigationViewModel: NSObject, ObservableObject, ARSCNViewDelegate, CLLocationManagerDelegate {
    @Published var instructions = ""
    @Published var distanceToDestination: CLLocationDistance = 0.0
    @Published var isSetupComplete = false
    @Published var headingOffset: Double = 0.0  // For device heading

    private let locationManager = CLLocationManager()
    private var destination: CLLocation?
    private var userLocation: CLLocation?
    private var userHeading: Double?
    private weak var arView: ARSCNView?
    private var markerNode: SCNNode?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingHeading()  // Enable heading updates
    }

    func setupARView(_ view: ARSCNView, destination: CLLocationCoordinate2D) {
        arView = view
        arView?.delegate = self
        self.destination = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        startTracking()
    }
    private func startTracking() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        guard ARWorldTrackingConfiguration.isSupported else {
            instructions = "AR navigation not supported on this device"
            return
        }

        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading
        arView?.session.run(configuration)
    }

    // MARK: - Location Manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
        updateNavigation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        userHeading = newHeading.trueHeading
        updateNavigation()
    }

    // MARK: - Navigation Logic
    private func updateNavigation() {
        guard let user = userLocation,
              let dest = destination,
              let heading = userHeading else { return }

        let distance = user.distance(from: dest)
        distanceToDestination = distance
        isSetupComplete = true

        // Calculate relative bearing
        let bearing = user.bearing(to: dest)
        headingOffset = (bearing - heading + 360).truncatingRemainder(dividingBy: 360)
        
        switch distance {
        case ..<10:
            instructions = "Destination reached"
            removeARMarker()
        default:
            instructions = "Walk \(Int(distance)) meters \(directionFromBearing(headingOffset))"
            placeARMarker(at: dest)
        }
    }

    private func directionFromBearing(_ bearing: Double) -> String {
        switch bearing {
        case 0..<22.5: return "straight ahead"
        case 22.5..<67.5: return "slightly to your right"
        case 67.5..<112.5: return "to your right"
        case 112.5..<157.5: return "behind to your right"
        case 157.5..<202.5: return "behind you"
        case 202.5..<247.5: return "behind to your left"
        case 247.5..<292.5: return "to your left"
        case 292.5..<337.5: return "slightly to your left"
        default: return "ahead"
        }
    }

    // MARK: - AR Functions
    private func placeARMarker(at location: CLLocation) {
        guard let userLocation = userLocation,
              let arView = arView else { return }
        
        // Calculate relative position
        let bearing = userLocation.bearing(to: location)
        let distance = userLocation.distance(from: location)
        let position = calculatePosition(bearing: bearing, distance: distance)
        
        // Create marker
        let sphere = SCNSphere(radius: 0.5)
        sphere.firstMaterial?.diffuse.contents = UIColor.systemRed
        let node = SCNNode(geometry: sphere)
        node.position = position
        
        // Add/replace marker
        markerNode?.removeFromParentNode()
        arView.scene.rootNode.addChildNode(node)
        markerNode = node
    }
    
    private func calculatePosition(bearing: Double, distance: Double) -> SCNVector3 {
        let angle = bearing.degreesToRadians
        let x = distance * sin(angle)
        let z = distance * cos(angle)
        return SCNVector3(x: Float(x), y: 0, z: Float(-z)) // Adjust for scene orientation
    }
    
    private func removeARMarker() {
        markerNode?.removeFromParentNode()
        markerNode = nil
    }

    func stopNavigation() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
        arView?.session.pause()
        removeARMarker()
    }
}
