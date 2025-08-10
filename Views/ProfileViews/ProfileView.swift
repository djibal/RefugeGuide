//
//  ProfileView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 10/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import FirebaseAuth
import SwiftUICore


struct ProfileView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    @State private var showDeleteConfirmation = false
    @State private var showDocumentManager = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @StateObject private var viewModel = ProfileViewModel()
    
    let primaryColor = Color(hex: "#0D3B66")  // Rich blue
    let accentColor = Color(hex: "#F95738")   // Bright coral-red
    let cardColor = Color(hex: "#FFFFFF")     // White
    let backgroundColor = Color(hex: "#F5F9FF") // Soft blue-white
    let textPrimary = Color(hex: "#1A1A1A")   // Neutral dark
    let textSecondary = Color(hex: "#555555") // Medium gray
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading profile...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    profileForm
                }
            }
            .navigationTitle("My Profile")
            .sheet(isPresented: $showDocumentManager) {
                DocumentManagerView()
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear(perform: loadUserDetails)
        }
    }
    
    private var profileForm: some View {
        Form {
            userInfoSection
            
            Section(header: Text("Documents")) {
                Button("Manage My Documents") {
                    showDocumentManager = true
                }
                
                NavigationLink("Case Status Tracker") {
                    CaseStatusView()
                }
            }
            
            Section(header: Text("Appointments")) {
                NavigationLink("Scheduled Appointments") {
                    AppointmentsView()
                }
                
                NavigationLink("Book New Appointment") {
                    BookAppointmentView()
                }
            }
            
            resourcesSection
            
            accountSection
            
            legalSection
        }
    }
    
    private var userInfoSection: some View {
        Section(header: Text("Account Information")) {
            if let user = authVM.currentUser {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(user.displayName ?? "Not provided")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Email")
                    Spacer()
                    Text(user.email ?? "No email")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Phone")
                    Spacer()
                    Text(user.phoneNumber ?? "Not provided")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("User Type")
                    Spacer()
                    Text(authVM.userType?.displayName ?? "Unknown")
                        .foregroundColor(.secondary)
                }
                
                  if let details = viewModel.userDetails {
                    HStack {
                        Text("Case Reference")
                        Spacer()
                        Text(details.caseReference ?? "Not assigned")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Legal Status")
                        Spacer()
                        Text(details.legalStatus.displayName)
                            .foregroundColor(details.legalStatus.color)
                    }
                }
            }
            
            NavigationLink("Edit Profile") {
                EditProfileView(userDetails: $viewModel.userDetails)
            }
        }
    }
    
    private var resourcesSection: some View {
        Section(header: Text("Resources")) {
            NavigationLink("UK Legal Resources") {
                UKLegalResourcesView()
            }
            
            NavigationLink("Local Support Services") {
                LocalServicesView()
            }
            
            NavigationLink("Language Assistance") {
                LanguageAssistanceView()
            }
        }
    }
    
    private var accountSection: some View {
        Section {
            Button("Sign Out", role: .destructive) {
                signOut()
            }
            
            Button("Delete My Account", role: .destructive) {
                showDeleteConfirmation = true
            }
            .alert("Delete Account", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    deleteAccount()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently delete your account and all associated data. This action cannot be undone.")
            }
        }
    }
    
    private var legalSection: some View {
        Section {
            UKLegalNotice(text: "The information provided in this app is for general guidance only and does not constitute legal advice.")
            
            Link(destination: URL(string: "https://www.gov.uk/asylum")!) {
                HStack {
                    Image(systemName: "info.circle")
                    Text("UK Asylum Information")
                }
            }
        }
    }
    
    private func loadUserDetails() {
        guard let userId = Auth.auth().currentUser?.uid else {
            viewModel.isLoading = false
            return
        }
        
        Task {
            do {
                viewModel.userDetails = try await UserService.fetchUserDetails(userId: userId)
                viewModel.isLoading = false
            } catch {
                errorMessage = "Failed to load user details: \(error.localizedDescription)"
                showErrorAlert = true
                viewModel.isLoading = false
            }
        }
    }
    
    private func signOut() {
        do {
            try authVM.signOut()
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }
    
    private func deleteAccount() {
        authVM.deleteAccount { error in
            if let error = error {
                errorMessage = error.localizedDescription
                showErrorAlert = true
            }
        }
    }
}

    enum CodingKeys: String, CodingKey {
        case caseReference = "case_reference"
        case legalStatus = "legal_status"
        case arrivalDate = "arrival_date"
        case nationality, language
    }


// MARK: - Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let authVM = AuthenticationViewModel()
        authVM.currentUser = Auth.auth().currentUser
        authVM.userType = .refugee
        
        return ProfileView()
            .environmentObject(authVM)
    }
}
