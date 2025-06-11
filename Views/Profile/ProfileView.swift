//
//  ProfileView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 10/06/2025.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State private var userEmail: String? = Auth.auth().currentUser?.email
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account")) {
                    if let email = userEmail {
                        HStack {
                            Text("Email")
                            Spacer()
                            Text(email)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Button("Sign Out", role: .destructive) {
                        signOut()
                    }
                }
                
                Section(header: Text("Data & Privacy")) {
                    Button("Delete My Account", role: .destructive) {
                        showAlert = true
                    }
                }
            }
            .navigationTitle("Profile")
            .alert("Are you sure you want to delete your account?", isPresented: $showAlert) {
                Button("Delete", role: .destructive) {
                    deleteAccount()
                }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            print("\u{2705} Signed out successfully")
            // Redirect to login screen if needed
        } catch {
            print("\u{274C} Sign out failed: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        Auth.auth().currentUser?.delete { error in
            if let error = error {
                print("\u{274C} Account deletion failed: \(error.localizedDescription)")
            } else {
                print("\u{2705} Account deleted")
                // Redirect or reset app flow if needed
            }
        }
    }
 }
