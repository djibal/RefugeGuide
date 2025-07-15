//
//  MainTabView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/06/2025.
//

import SwiftUI
import FirebaseFunctions
import SwiftUICore

struct MainTabView: View {
    
    // Optional: use centralized AppColors if available
    let primaryColor = Color(hex: "#0D3B66")     // Deep blue
    let accentColor = Color(hex: "#F95738")      // Coral red
    let backgroundColor = Color(hex: "#F5F9FF")  // Light background
    let cardColor = Color.white
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

    var body: some View {
        TabView {
            
            // Dashboard
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
            
            // Local Services
            LocalServicesView()
                .tabItem {
                    Label("Services", systemImage: "location.circle.fill")
                }
            
            // Community Forum
            CommunityView()
                .tabItem {
                    Label("Community", systemImage: "person.3.fill")
                }
            
            // Document Vault
            MyDocumentsView()
                .tabItem {
                    Label("Documents", systemImage: "doc.fill")
                }
            
            // More Menu (Grid-style)
            NavigationView {
                MoreMenuView()
            }
            .tabItem {
                Label("More", systemImage: "ellipsis.circle")
            }
        }
    }
}

