//
//   HelpResourcesView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 16/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions

struct HelpResourcesView: View {
    @StateObject private var viewModel = HelpResourcesViewModel()
    @State private var showSafetyPlan = false

    var body: some View {
        NavigationStack {
            List(viewModel.resources) { resource in
                Button {
                    if resource.type == .inApp {
                        showSafetyPlan = true
                    } else {
                        viewModel.handleResourceTap(resource)
                    }
                } label: {
                    ResourceRowView(resource: resource)
                }
                .buttonStyle(.plain)
            }
            .listStyle(.plain)
            .navigationTitle(NSLocalizedString("Help Resources", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showSafetyPlan) {
                SafetyPlanView()
            }
        }
    }
}
