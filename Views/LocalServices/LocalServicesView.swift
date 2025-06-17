//
//  LocalServicesView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 17/06/2025.
//

import SwiftUI
import FirebaseFirestoreSwift
import CoreLocation
import MapKit

struct LocalServicesView: View {
    @FirestoreQuery(collectionPath: "services") var services: [LocalService]
    @State private var searchText = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.5072, longitude: -0.1276),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    var filteredServices: [LocalService] {
        if searchText.isEmpty {
            return services
        }
        return services.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: LocalServicesMapView(services: services)) {
                        Label(NSLocalizedString("View on Map", comment: ""), systemImage: "map")
                    }
                }

                ForEach(filteredServices) { service in
                    NavigationLink(destination: ServiceDetailView(service: service)) {
                        ServiceCard(service: service)
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationTitle(NSLocalizedString("Local Services", comment: ""))
        }
    }
}

struct ServiceCard: View {
    let service: LocalService

    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: service.imageUrl ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            
            .frame(width: 80, height: 80)
            .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(service.name)
                    .font(.headline)

                Text(service.category)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack {
                    Text("\(service.discount)% \(NSLocalizedString("OFF", comment: ""))")
                        .foregroundColor(.green)
                    Spacer()
                    Text(service.distanceString)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
