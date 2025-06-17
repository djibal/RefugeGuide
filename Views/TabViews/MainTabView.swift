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

            HelpChatView()
                .tabItem {
                    Label("Help", systemImage: "questionmark.bubble")
                }

            HelpResourcesView()
                .tabItem {
                    Label("Resources", systemImage: "lifepreserver")
                }

            MyDocumentsView()
                .tabItem {
                    Label("Documents", systemImage: "doc.text")
                }

            UploadDocumentView()
                .tabItem {
                    Label("Upload", systemImage: "square.and.arrow.up")
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
