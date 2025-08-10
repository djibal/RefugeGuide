//
//  MoreMenuView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 20/07/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import SwiftUICore
import SwiftUI

    struct MoreMenuView: View {
        private let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        let primaryColor = Color(hex: "#0D3B66")
        let accentColor = Color(hex: "#F95738")
        let backgroundColor = Color(hex: "#F5F9FF")
        let cardColor = Color(hex: "#FFFFFF")
        let textPrimary = Color(hex: "#1A1A1A")
        let textSecondary = Color(hex: "#555555")

        var body: some View {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 24) {
                        MoreMenuItem(title: "AI Help Chat", icon: "message.fill", destination: AnyView(HelpChat()))
                        MoreMenuItem(title: "Help Resources", icon: "book.fill", destination: AnyView(HelpResourcesView()))
                        MoreMenuItem(title: "Safety Plan", icon: "shield.lefthalf.fill", destination: AnyView(SafetyPlanView()))
                        MoreMenuItem(title: "Consultations", icon: "video.fill", destination: AnyView(ConsultationListWrapper()))
                        MoreMenuItem(title: "Legal Directory", icon: "scales.circle.fill", destination: AnyView(LegalDirectoryView()))
                        MoreMenuItem(title: "Upload Document", icon: "tray.and.arrow.up.fill", destination: AnyView(UploadDocumentView()))
                        MoreMenuItem(title: "Profile", icon: "person.crop.circle", destination: AnyView(ProfileView()))
                        MoreMenuItem(title: "Settings", icon: "gearshape.fill", destination: AnyView(SettingsView()))
                        MoreMenuItem(title: "AR Navigation", icon: "location.viewfinder", destination: AnyView(ARNavigationWrapper()))
                        MoreMenuItem(title: "Document AI", icon: "doc.text.magnifyingglass", destination: AnyView(DocumentAIView()))
                        MoreMenuItem(title: "eVisa", icon: "doc.richtext", destination: AnyView(EVisaView()))
                        MoreMenuItem(title: "eVisa Info", icon: "creditcard.fill", destination: AnyView(EVisaInfoView()))
                    }
                    .padding()
                }
                .navigationTitle("Menu")
                .background(AppColors.background.ignoresSafeArea())
            }
        }
    }
