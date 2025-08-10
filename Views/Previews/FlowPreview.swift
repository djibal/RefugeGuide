//
//  FlowPreview.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 16/06/2025.

import Foundation
import SwiftUI
import FirebaseFunctions
<<<<<<< HEAD
import SwiftUICore

struct FlowPreview: View {
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")
=======

struct FlowPreview: View {
    

>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
    
    let mockConsultation = Consultation(
        id: "mock123",
        date: Date(),
        type: .legal,             // must be one of: .legal, .medical, .housing, .psychological
        status: .scheduled,       // must be one of: .scheduled, .completed, .cancelled, .inProgress
        specialistID: "testSpecialist001",
        notes: "Test consultation for preview."
    )

    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("🌍 Welcome View", destination: WelcomeView(onContinue: {}))
                NavigationLink("🌍 Language Picker", destination: LanguagePickerView(onContinue: {}))
                NavigationLink("🧍 User Type Selection", destination: UserTypeSelectionView(onSelect: { _ in }))
                NavigationLink("📝 Registration View", destination: RegistrationView(onComplete: {}))
                NavigationLink("🔑 Sign In View", destination: SignInView())
                NavigationLink("📄 Upload Document View", destination: UploadDocumentView())
                NavigationLink("📁 My Documents View", destination: MyDocumentsView())
                NavigationLink("💬 Help Chat ", destination: HelpChat())
                NavigationLink("👥 Community View", destination: CommunityView())
                NavigationLink("👤 Profile view", destination: ProfileView())
                NavigationLink("🆘 Emergency Help View", destination: HelpResourcesView())
                NavigationLink("📹 Video Consultation View", destination: VideoConsultationView(consultation: mockConsultation))
                NavigationLink("🏠 Main Tab View (Full App)", destination: MainTabView())
            }
            .navigationTitle("🔍 RefugeGuide Previews")
        }
    }
}

#Preview {
    FlowPreview()
}
