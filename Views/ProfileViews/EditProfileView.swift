//
//  EditProfileView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SwiftUICore

struct EditProfileView: View {
    @Binding var userDetails: UserDetails?
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var nationality = ""
    @State private var preferredLanguage = ""
    @State private var arrivalDate = Date()
    @State private var isSaving = false
    @State private var errorMessage: String?
    
    let primaryColor = Color(hex: "#0D3B66")  // Rich blue
    let accentColor = Color(hex: "#F95738")   // Bright coral-red
    let cardColor = Color(hex: "#FFFFFF")     // White
    let backgroundColor = Color(hex: "#F5F9FF") // Soft blue-white
    let textPrimary = Color(hex: "#1A1A1A")   // Neutral dark
    let textSecondary = Color(hex: "#555555") // Medium gray

    var body: some View {
        Form {
            Section(header: Text("Personal Info")) {
                TextField("Full Name", text: $name)
                TextField("Nationality", text: $nationality)
                TextField("Preferred Language", text: $preferredLanguage)
                DatePicker("Arrival Date", selection: $arrivalDate, displayedComponents: .date)
            }

            Button(action: saveProfile) {
                if isSaving {
                    ProgressView()
                } else {
                    Text("Save Changes")
                }
            }
        }
        .navigationTitle("Edit Profile")
        .onAppear(perform: populateForm)
        .alert("Error", isPresented: .constant(errorMessage != nil), actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text(errorMessage ?? "")
        })
    }

    private func populateForm() {
        name = Auth.auth().currentUser?.displayName ?? ""
        nationality = userDetails?.nationality ?? ""
        preferredLanguage = userDetails?.language ?? ""
        arrivalDate = userDetails?.arrivalDate ?? Date()
    }

    private func saveProfile() {
        guard let uid = Auth.auth().currentUser?.uid else {
            errorMessage = "Not logged in"
            return
        }

        isSaving = true

        let updates: [String: Any] = [
            "nationality": nationality,
            "language": preferredLanguage,
            "arrival_date": Timestamp(date: arrivalDate)
        ]

        Firestore.firestore().collection("users").document(uid).updateData(updates) { error in
            isSaving = false
            if let error = error {
                errorMessage = "Failed to save: \(error.localizedDescription)"
            } else {
                userDetails?.nationality = nationality
                userDetails?.language = preferredLanguage
                userDetails?.arrivalDate = arrivalDate
                dismiss()
            }
        }
    }
}
