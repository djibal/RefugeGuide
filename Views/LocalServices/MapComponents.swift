//
//  MapComponents.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 17/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore
@preconcurrency import MapKit

// MARK: - Map Annotation View
struct MapAnnotationView: View {
    let service: LocalService
    let isSelected: Bool

    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(isSelected ? .blue : .white)
                    .frame(width: 32, height: 32)
                    .shadow(radius: 3)
                
                Image(systemName: iconForCategory(service.category))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(isSelected ? .white : .blue)
            }
            
            if isSelected {
                Text(service.name)
                    .font(.caption2)
                    .padding(4)
                    .background(.ultraThinMaterial)
                    .cornerRadius(4)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    private func iconForCategory(_ category: String) -> String {
        switch category.lowercased() {
        case "food": return "fork.knife"
        case "housing": return "house.fill"
        case "legal": return "scale.fill"
        case "medical": return "cross.fill"
        case "education": return "book.fill"
        case "employment": return "briefcase.fill"
        default: return "mappin"
        }
    }
}

// MARK: - Service Detail Sheet
struct ServiceDetailSheet: View {
    let service: LocalService
    let onGetDirections: (LocalService) -> Void
    let onClose: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(service.name)
                    .font(.title2.bold())
                
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                Image(systemName: "tag.fill")
                    .foregroundColor(.blue)
                Text(service.category)
            }
            
            if let rating = service.rating, rating > 0 {
                HStack {
                    Image(systemName: "star.fill")
                        .background(AppColors.accent) 
                    Text(String(format: "%.1f", rating))
                }
            }
            
            if let discount = service.discount, discount > 0 {
                Text("\(discount)% OFF")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            
            Text(service.description)
                .padding(.vertical)
            
            Button(action: { onGetDirections(service) }) {
                Label("Get Directions", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .background(AppColors.primary)
                    .cornerRadius(12)
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
        }
        .padding()
        .presentationDetents([.height(300), .medium])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Filter Sheet
struct FilterSheet: View {
    let categories: Set<String>
    @Binding var selectedCategories: Set<String>
    
    var body: some View {
        NavigationStack {
            List(Array(categories).sorted(), id: \.self) { category in
                HStack {
                    Text(category)
                    Spacer()
                    if selectedCategories.contains(category) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if selectedCategories.contains(category) {
                        selectedCategories.remove(category)
                    } else {
                        selectedCategories.insert(category)
                    }
                }
            }
            .navigationTitle("Filter Categories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {}
                }
            }
        }
    }
}

// MARK: - Map Route Overlay
struct MapRouteOverlay: Shape {
    let route: MKRoute
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        guard route.polyline.pointCount > 0 else { return path }

        
        let points = route.polyline.points()
        path.move(to: points[0].cgPoint)
        
        for i in 1..<route.polyline.pointCount {
            path.addLine(to: points[i].cgPoint)
        }
        
        return path
    }
}

// MARK: - Helper Extensions
extension MKMapPoint {
    var cgPoint: CGPoint {
        CGPoint(x: x, y: y)
    }
}

extension Array where Element == CLLocationCoordinate2D {
    var centerPoint: CLLocationCoordinate2D {
        let count = Double(self.count)
        let sum = reduce((latitude: 0.0, longitude: 0.0)) {
            ($0.latitude + $1.latitude, $0.longitude + $1.longitude)
        }
        return CLLocationCoordinate2D(
            latitude: sum.latitude / count,
            longitude: sum.longitude / count
        )
    }
    
    var span: (latitudeDelta: Double, longitudeDelta: Double) {
        let latitudes = map(\.latitude)
        let longitudes = map(\.longitude)
        
        guard let minLat = latitudes.min(),
              let maxLat = latitudes.max(),
              let minLon = longitudes.min(),
              let maxLon = longitudes.max() else {
            return (0.1, 0.1)
        }
        
        return (
            latitudeDelta: Swift.max(0.05, (maxLat - minLat) * 1.2),
            longitudeDelta: Swift.max(0.05, (maxLon - minLon) * 1.2)
        )
    }
}

extension MKMapRect {
    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: origin.coordinate,
            span: MKCoordinateSpan(
                latitudeDelta: size.height * 0.5 / 111_000,
                longitudeDelta: size.width * 0.5 / 111_000
            )
        )
    }
}
