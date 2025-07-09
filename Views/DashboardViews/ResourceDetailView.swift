//
//  ResourceDetailView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
//


import SwiftUI
import MapKit
import FirebaseFirestoreInternal

struct ResourceDetailView: View {
    let resource: HelpResource
    @State private var region: MKCoordinateRegion?
    @State private var showDirections = false
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                
                contactSection
                
                if let location = resource.location {
                    let geoPoint = GeoPoint(latitude: location.latitude, longitude: location.longitude)
                    mapSection(location: geoPoint)
                }

                additionalInfoSection
                
                actionButtons
            }
            .padding()
        }
        .navigationTitle(resource.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: resource.iconName)
                    .foregroundColor(.accentColor)
                    .font(.title)
                
                Text(resource.category.displayName)
                    .font(.subheadline)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.accentColor.opacity(0.2))
                    .cornerRadius(8)
                
                if resource.isUrgent {
                    Text("URGENT")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red.opacity(0.2))
                        .foregroundColor(.red)
                        .cornerRadius(8)
                }
            }
            
            Text(resource.description)
                .font(.body)
                .padding(.top, 4)
        }
    }
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Contact Information")
                .font(.headline)
                .padding(.bottom, 4)
            
            if let urlString = resource.urlString, let url = URL(string: urlString) {
                Link(destination: url) {
                    HStack {
                        Image(systemName: "globe")
                        Text("Website")
                        Spacer()
                        Image(systemName: "arrow.up.forward")
                    }
                    .foregroundColor(.blue)
                }
            }
            
            if !resource.contactInfo.isEmpty {
                HStack {
                    Image(systemName: "phone.fill")
                    Text(resource.contactInfo)
                    Spacer()
                    Button(action: {
                        callResource()
                    }) {
                        Image(systemName: "phone.connection")
                    }
                }
            }
            
            if !resource.languages.isEmpty {
                HStack(alignment: .top) {
                    Image(systemName: "bubble.left.and.bubble.right")
                    VStack(alignment: .leading) {
                        Text("Languages:")
                            .font(.subheadline)
                        Text(resource.languages.joined(separator: ", "))
                            .font(.caption)
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private func mapSection(location: GeoPoint) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Location")
                .font(.headline)
            
            let coordinate = CLLocationCoordinate2D(
                latitude: location.latitude,
                longitude: location.longitude
            )
            
            Map(coordinateRegion: .constant(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            ), annotationItems: [IdentifiableCoordinate(coordinate: coordinate)]) { item in
                MapMarker(coordinate: item.coordinate)
            }
            .frame(height: 200)
            .cornerRadius(12)
            .onAppear {
                region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            }
            
            if let distance = resource.distance, distance > 0 {
                Text("Distance: \(String(format: "%.1f", distance / 1000)) km")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var additionalInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Additional Information")
                .font(.headline)
            
            Text("This service is available to all refugees and asylum seekers in the UK regardless of immigration status. Identification may be required for some services.")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
    
    private var actionButtons: some View {
        HStack {
            Button(action: shareResource) {
                Label("Share", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            
            if resource.location != nil {
                Button(action: { showDirections = true }) {
                    Label("Directions", systemImage: "arrow.triangle.turn.up.right.diamond")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .sheet(isPresented: $showDirections) {
            if let location = resource.location {
                DirectionsView(destination: CLLocationCoordinate2D(
                    latitude: location.latitude,
                    longitude: location.longitude
                ))
            }
        }
    }
    
    private func callResource() {
        let cleanNumber = resource.contactInfo.filter { $0.isNumber }
        guard let url = URL(string: "tel://\(cleanNumber)"),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    private func shareResource() {
        let text = "\(resource.title): \(resource.description)\nContact: \(resource.contactInfo)"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true)
    }
}

struct IdentifiableCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct DirectionsView: View {
    let destination: CLLocationCoordinate2D
    
    var body: some View {
        VStack {
            Text("Get Directions")
                .font(.title2)
                .padding()
            
            if let mapURL = URL(string: "http://maps.apple.com/?daddr=\(destination.latitude),\(destination.longitude)") {
                Link("Open in Apple Maps", destination: mapURL)
                    .buttonStyle(.borderedProminent)
                    .padding()
            }
            
            if let googleURL = URL(string: "comgooglemaps://?daddr=\(destination.latitude),\(destination.longitude)&directionsmode=walking") {
                if UIApplication.shared.canOpenURL(googleURL) {
                    Link("Open in Google Maps", destination: googleURL)
                        .buttonStyle(.bordered)
                        .padding()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}
