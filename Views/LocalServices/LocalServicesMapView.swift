//
//  LocalServicesMapView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 17/06/2025.
//

import SwiftUI
import MapKit

struct LocalServicesMapView: View {
    let services: [LocalService]
    @State private var region: MKCoordinateRegion
    @State private var selectedService: LocalService?
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var showFilters = false
    @State private var selectedCategories: Set<String> = []
    @State private var searchText = ""
    @State private var showDirections = false
    @State private var route: MKRoute?

    private let locationManager = CLLocationManager()

    private var filteredServices: [LocalService] {
        services.filter { service in
            let matchesCategory = selectedCategories.isEmpty || selectedCategories.contains(service.category)
            let matchesSearch = searchText.isEmpty ||
                service.name.localizedCaseInsensitiveContains(searchText) ||
                service.description.localizedCaseInsensitiveContains(searchText)
            return matchesCategory && matchesSearch
        }
    }

    init(services: [LocalService]) {
        self.services = services
        let coordinates = services.map { $0.coordinate }
        let center = coordinates.centerPoint
        let span = coordinates.span
        self._region = State(initialValue: MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: span.latitudeDelta * 1.5, longitudeDelta: span.longitudeDelta * 1.5)
        ))
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(
                coordinateRegion: $region,
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode,
                annotationItems: filteredServices,
                annotationContent: { service in
                    MapAnnotation(coordinate: service.coordinate) {
                        MapAnnotationView(service: service, isSelected: selectedService?.id == service.id)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    selectedService = service
                                    centerMapOnService(service)
                                }
                            }
                    }
                }
            )
            .overlay(routeOverlay)
            .ignoresSafeArea()
            .sheet(item: $selectedService) { service in
                ServiceDetailSheet(service: service, onGetDirections: getDirections, onClose: { selectedService = nil })
            }

            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                    TextField("Search services...", text: $searchText)
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill").foregroundColor(.secondary)
                        }
                    }
                }
                .padding(10)
                .background(.ultraThinMaterial)
                .cornerRadius(12)

                Button(action: { showFilters.toggle() }) {
                    Label("Filters", systemImage: "slider.horizontal.3")
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
                .sheet(isPresented: $showFilters) {
                    FilterSheet(
                        categories: Set(services.map { $0.category }),
                        selectedCategories: $selectedCategories
                    )
                }

                Button(action: centerOnUserLocation) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 20))
                        .frame(width: 44, height: 44)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
            }
            .padding(16)
        }
        .navigationTitle("Local Services")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var routeOverlay: some View {
        Group {
            if let route, showDirections {
                MapRouteOverlay(route: route)
                    .stroke(.blue, lineWidth: 5)
                    .background(
                        MapRouteOverlay(route: route)
                            .stroke(.white, lineWidth: 7)
                    )
            }
        }
    }

    private func centerOnUserLocation() {
        guard let location = locationManager.location else {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        withAnimation {
            region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            userTrackingMode = .follow
        }
    }

    private func centerMapOnService(_ service: LocalService) {
        withAnimation {
            region.center = service.coordinate
            region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        }
    }

    private func getDirections(for service: LocalService) {
        guard let userLocation = locationManager.location else {
            locationManager.requestWhenInUseAuthorization()
            return
        }

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: service.coordinate))
        request.transportType = .walking

        Task {
            do {
                let directions = MKDirections(request: request)
                let response = try await directions.calculate()
                guard let route = response.routes.first else { return }
                await MainActor.run {
                    withAnimation {
                        self.route = route
                        self.showDirections = true
                        self.region = route.polyline.boundingMapRect.region
                    }
                }
            } catch {
                print("Directions error: \(error.localizedDescription)")
            }
        }
    }
}
