
//  ResourceListView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
//
import Foundation
import SwiftUI
import CoreLocation

struct ResourceListView: View {
    @StateObject private var viewModel = ResourceListViewModel()
    @State private var searchText = ""
    @State private var selectedCategory: UserResourceCategory?
    @State private var showFilters = false

    var body: some View {
        NavigationView {
            List {
                if viewModel.isLoading {
                    ProgressView("Loading UK resources...")
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                // Quick access to urgent resources
                if !viewModel.urgentResources.isEmpty {
                    Section(header: Text("Urgent Support").font(.headline)) {
                        ForEach(viewModel.urgentResources) { resource in
                            ResourceRowView(resource: resource)
                        }
                    }
                }

                // Filtered resources
                Section(header: Text("All Resources").font(.headline)) {
                    ForEach(filteredResources) { resource in
                        NavigationLink(destination: ResourceDetailView(resource: resource)) {
                            ResourceRowView(resource: resource)
                        }
                    }

                    if filteredResources.isEmpty && !viewModel.isLoading {
                        Text("No resources match your filters")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .listStyle(.grouped)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("UK Support Services")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showFilters.toggle() }) {
                        Label("Filters", systemImage: "line.3.horizontal.decrease.circle")
                            .symbolVariant(selectedCategory == nil ? .none : .fill)
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                FilterView(selectedCategory: $selectedCategory)
            }
        }
        .onAppear {
            viewModel.fetchResources()
        }
    }

    private var filteredResources: [HelpResource] {
        var resources = viewModel.resources

        if let category = selectedCategory {
            resources = resources.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            resources = resources.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText) ||
                $0.contactInfo.localizedCaseInsensitiveContains(searchText)
            }
        }

        return resources
    }
}

struct FilterView: View {
    @Binding var selectedCategory: UserResourceCategory?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List(UserResourceCategory.allCases, id: \.self) { category in
                CategoryButton(category: category, selectedCategory: $selectedCategory)
            }
            .listStyle(.grouped)
            .navigationTitle("Filter Resources")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CategoryButton: View {
    let category: UserResourceCategory
    @Binding var selectedCategory: UserResourceCategory?

    var body: some View {
        Button(action: {
            selectedCategory = (selectedCategory == category) ? nil : category
        }) {
            HStack {
                Image(systemName: category.systemIcon)
                    .foregroundColor(selectedCategory == category ? .accentColor : .primary)

                Text(category.displayName)

                Spacer()

                if selectedCategory == category {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                }
            }
        }
        .foregroundColor(.primary)
    }
}

class ResourceListViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var resources: [HelpResource] = []
    @Published var urgentResources: [HelpResource] = []
    @Published var isLoading = false
    @Published var errorMessage = ""

    private let locationManager = CLLocationManager()
    private var userLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
    }

    func fetchResources() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.resources = ukSampleResources // ✅ correct, if ukSampleResources is [HelpResource]
            self.urgentResources = self.resources.filter { $0.isUrgent }
            self.calculateDistances()
            self.isLoading = false
        }
    }
    private func calculateDistances() {
        guard let userLocation = userLocation else { return }

        resources = resources.map { resource in
            var updated = resource
            if let loc = resource.location {
                let locA = CLLocation(latitude: loc.latitude, longitude: loc.longitude)
                updated.distance = userLocation.distance(from: locA)
            }
            return updated
        }

        resources.sort {
            ($0.distance ?? Double.greatestFiniteMagnitude) < ($1.distance ?? Double.greatestFiniteMagnitude)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
        calculateDistances()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "Location error: \(error.localizedDescription)"
    }
}
