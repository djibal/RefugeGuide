//
//  LocationManager.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 17/06/2025.
//


import Foundation
import CoreLocation
import Combine
import UIKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    private let manager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?

    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published private(set) var currentLocation: CLLocation?
    @Published private(set) var locationError: LocationError?
    @Published private(set) var isUpdatingLocation = false

    private var backgroundTaskID: UIBackgroundTaskIdentifier?
    private var lastLocationTimestamp: Date?
    private var significantChangeMonitoring = false

    override private init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.activityType = .other
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = true
    }

    func requestLocation() async throws -> CLLocation {
        guard isLocationServicesAvailable else {
            throw LocationError.servicesDisabled
        }

        return try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation

            if authorizationStatus == .notDetermined {
                manager.requestWhenInUseAuthorization()
            } else if authorizationStatus == .denied {
                continuation.resume(throwing: LocationError.denied)
                locationContinuation = nil
            } else {
                manager.requestLocation()
            }
        }
    }

    func startUpdatingLocation(significantChangesOnly: Bool = false, accuracy: CLLocationAccuracy = kCLLocationAccuracyHundredMeters) {
        guard isLocationServicesAvailable else {
            locationError = .servicesDisabled
            return
        }

        if authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }

        guard authorizationStatus.isAuthorized else {
            locationError = .denied
            return
        }

        significantChangeMonitoring = significantChangesOnly
        manager.desiredAccuracy = accuracy

        if significantChangeMonitoring {
            manager.startMonitoringSignificantLocationChanges()
        } else {
            manager.startUpdatingLocation()
        }

        isUpdatingLocation = true
        startBackgroundTask()
    }

    func stopUpdatingLocation() {
        if significantChangeMonitoring {
            manager.stopMonitoringSignificantLocationChanges()
        } else {
            manager.stopUpdatingLocation()
        }

        isUpdatingLocation = false
        endBackgroundTask()
    }

    func requestAuthorization() {
        let status = manager.authorizationStatus

        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            locationError = .denied
        case .authorizedWhenInUse, .authorizedAlways:
            break
        @unknown default:
            locationError = .unknown
        }
    }

    func getPlacemark() async throws -> CLPlacemark {
        guard let location = currentLocation else {
            throw LocationError.noLocation
        }

        let geocoder = CLGeocoder()
        return try await geocoder.reverseGeocodeLocation(location).first!
    }

    var isLocationServicesAvailable: Bool {
        CLLocationManager.locationServicesEnabled()
    }

    var isAuthorized: Bool {
        authorizationStatus.isAuthorized
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        guard location.timestamp.timeIntervalSinceNow > -1 else { return }

        if let lastLocation = currentLocation,
           lastLocation.coordinate.latitude == location.coordinate.latitude,
           lastLocation.coordinate.longitude == location.coordinate.longitude,
           location.horizontalAccuracy >= lastLocation.horizontalAccuracy {
            return
        }

        currentLocation = location
        lastLocationTimestamp = Date()

        if let continuation = locationContinuation {
            continuation.resume(returning: location)
            locationContinuation = nil
        }

        objectWillChange.send()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let locationError: LocationError

        switch (error as NSError).code {
        case CLError.locationUnknown.rawValue:
            locationError = .locationUnknown
        case CLError.denied.rawValue:
            locationError = .denied
            stopUpdatingLocation()
        default:
            locationError = .other(error)
        }

        self.locationError = locationError

        if let continuation = locationContinuation {
            continuation.resume(throwing: locationError)
            locationContinuation = nil
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationError = nil
        case .denied, .restricted:
            locationError = .denied
            stopUpdatingLocation()
        case .notDetermined:
            break
        @unknown default:
            locationError = .unknown
        }

        objectWillChange.send()
    }

    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        if let error = error {
            locationError = .other(error)
        }
    }

    private func startBackgroundTask() {
        backgroundTaskID = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
    }

    private func endBackgroundTask() {
        if let taskID = backgroundTaskID {
            UIApplication.shared.endBackgroundTask(taskID)
            backgroundTaskID = nil
        }
    }
}

extension CLAuthorizationStatus {
    var isAuthorized: Bool {
        switch self {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .denied, .restricted, .notDetermined:
            return false
        @unknown default:
            return false
        }
    }
}

enum LocationError: Error, LocalizedError {
    case denied
    case servicesDisabled
    case locationUnknown
    case noLocation
    case timeout
    case unknown
    case other(Error)

    var errorDescription: String? {
        switch self {
        case .denied:
            return "Location access denied. Please enable in Settings."
        case .servicesDisabled:
            return "Location services are disabled on your device."
        case .locationUnknown:
            return "Unable to determine your location. Please try again."
        case .noLocation:
            return "No location data available."
        case .timeout:
            return "Location request timed out."
        case .unknown:
            return "An unknown location error occurred."
        case .other(let error):
            return error.localizedDescription
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .denied:
            return "Go to Settings > Privacy > Location Services to enable access."
        case .servicesDisabled:
            return "Enable Location Services in Settings."
        case .locationUnknown, .noLocation:
            return "Move to an open area and try again."
        case .timeout:
            return "Ensure you have GPS signal and try again."
        default:
            return nil
        }
    }
}
