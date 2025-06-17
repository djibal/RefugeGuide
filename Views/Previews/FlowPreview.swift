//
//  FlowPreview.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 16/06/2025.

import SwiftUI

struct FlowPreview: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("🌍 Welcome View", destination: WelcomeView())
                NavigationLink("🌍 Language Picker", destination: LanguagePickerView(onContinue: {}))
                NavigationLink("🧍‍♂️ User Type Selection", destination: UserTypeSelectionView())
                NavigationLink("📝 Registration View", destination: RegistrationView())
                NavigationLink("🔑 Sign In View", destination: SignInView())
                NavigationLink("📄 Upload Document View", destination: UploadDocumentView())
                NavigationLink("📁 My Documents View", destination: MyDocumentsView())
                NavigationLink("💬 Help Chat View", destination: HelpChatView())
                NavigationLink("👥 Community View", destination: CommunityView())
                NavigationLink("🆘 Emergency Help View", destination: HelpResourcesView())
                NavigationLink("📹 Video Consultation View", destination: VideoConsultationView())
                NavigationLink("🏠 Main Tab View (Full App)", destination: MainTabView())
            }
            .navigationTitle("🔍 RefugeGuide Previews")
        }
    }
}

#Preview {
    FlowPreview()
}
