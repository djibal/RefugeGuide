//
//  ServicesViewModel.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 17/06/2025.


import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation
import SwiftUICore

class ServicesViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var services: [LocalService] = []
    @Published var filteredServices: [LocalService] = []
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var selectedCategory: String? = nil
    @Published var userLocation: CLLocation?

    private var listener: ListenerRegistration?
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
    }

    func fetchServices() {
        isLoading = true
        listener = Firestore.firestore().collection("services")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                self.isLoading = false

                if let error = error {
                    self.errorMessage = "Error fetching services: \(error.localizedDescription)"
                    return
                }

                guard let documents = snapshot?.documents else {
                    self.errorMessage = "No services available"
                    return
                }

                self.services = documents.compactMap { doc in
                    try? doc.data(as: LocalService.self)
                }

                self.updateDistances()
                self.applyFilters()
            }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
        updateDistances()
        applyFilters()
    }

    private func updateDistances() {
        guard let userLocation = userLocation else { return }

        services = services.map { service in
            var updated = service
            let serviceLocation = CLLocation(latitude: service.latitude, longitude: service.longitude)
            updated.distance = userLocation.distance(from: serviceLocation)
            return updated
        }
    }

    func filter(by category: String?) {
        selectedCategory = category
        applyFilters()
    }

    private func applyFilters() {
        filteredServices = services

        // Filter by selected category
        if let category = selectedCategory {
            filteredServices = filteredServices.filter {
                $0.category.lowercased() == category.lowercased()
            }
        }

        filteredServices.sort {
            ($0.distance ?? Double.greatestFiniteMagnitude) <
            ($1.distance ?? Double.greatestFiniteMagnitude)
        }
    }

    deinit {
        listener?.remove()
    }
}
