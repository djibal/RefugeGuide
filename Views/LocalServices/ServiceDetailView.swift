//
//  ServiceDetailView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 17/06/2025.
//

import SwiftUI
import CoreLocation

struct ServiceDetailView: View {
    let service: LocalService
    @State private var userLocation: CLLocation? = LocationManager.shared.currentLocation

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(service.name)
                    .font(.title2.bold())

                HStack {
                    Label(service.category, systemImage: "tag")
                    if let rating = service.rating {
                        Spacer()
                        Label(String(format: "%.1f", rating), systemImage: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }

                Text(service.description)
                    .font(.body)

                if let hours = service.openingHours {
                    Label("Hours: \(hours)", systemImage: "clock")
                }

                if let distance = service.distance(from: userLocation) as String? {
                    Label("Distance: \(distance)", systemImage: "location")
                }

                if let phone = service.phone {
                    Link(destination: URL(string: "tel:\(phone)")!) {
                        Label("Call", systemImage: "phone.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }

                if let website = service.website, let url = URL(string: website) {
                    Link(destination: url) {
                        Label("Visit Website", systemImage: "globe")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            LocationManager.shared.requestAuthorization()
            if userLocation == nil {
                userLocation = LocationManager.shared.currentLocation
            }
        }
    }
}
