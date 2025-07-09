//
//  ContentView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 05/06/2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false

    var body: some View {
        if hasCompletedOnboarding {
            DashboardView()
        } else {
            WelcomeView {
                hasCompletedOnboarding = true
            }
        }
    }
}
