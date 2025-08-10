//
//   HelpResourcesView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 16/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct HelpResourcesView: View {
    @StateObject private var viewModel = HelpResourcesViewModel()
    @State private var showSafetyPlan = false
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

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
