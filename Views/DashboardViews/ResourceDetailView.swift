//
//  ResourceDetailView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
//


import SwiftUI

struct ResourceDetailView: View {
    let resource: Resource

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(resource.name)
                .font(.largeTitle)
                .bold()

            Text(resource.description)
                .font(.body)

            Spacer()
        }
        .padding()
        .navigationTitle(resource.name)
    }
}
