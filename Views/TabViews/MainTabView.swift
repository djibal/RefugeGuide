//
//  MainTabView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 03/06/2025.
//
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            HelpResourcesView()
                .tabItem {
                    Label("Resources", systemImage: "lifepreserver")
                }

            DocumentsView()
                .tabItem {
                    Label("Documents", systemImage: "doc.text")
                }

            CommunityView()
                .tabItem {
                    Label("Community", systemImage: "person.3")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    MainTabView()
}

