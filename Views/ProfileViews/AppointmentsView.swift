//
//  AppointmentsView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SwiftUICore

struct AppointmentsView: View {
    @State private var appointments: [Appointment] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    let primaryColor = Color(hex: "#0D3B66")  // Rich blue
    let accentColor = Color(hex: "#F95738")   // Bright coral-red
    let cardColor = Color(hex: "#FFFFFF")     // White
    let backgroundColor = Color(hex: "#F5F9FF") // Soft blue-white
    let textPrimary = Color(hex: "#1A1A1A")   // Neutral dark
    let textSecondary = Color(hex: "#555555") // Medium gray

    var body: some View {
        List {
            if isLoading {
                ProgressView("Loading...")
            } else if appointments.isEmpty {
                Text("You have no upcoming appointments.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(appointments) { appointment in
                    VStack(alignment: .leading) {
                        Text(appointment.type)
                            .font(.headline)
                        Text(appointment.scheduledAt.formatted(date: .abbreviated, time: .shortened))
                            .foregroundColor(.blue)
                        if !appointment.notes.isEmpty {
                            Text(appointment.notes)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .navigationTitle("My Appointments")
        .onAppear(perform: fetchAppointments)
        .alert("Error", isPresented: .constant(errorMessage != nil), actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text(errorMessage ?? "")
        })
    }

    private func fetchAppointments() {
        guard let uid = Auth.auth().currentUser?.uid else {
            errorMessage = "Not logged in"
            return
        }

        Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("appointments")
            .order(by: "scheduledAt")
            .getDocuments { snapshot, error in
                isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                appointments = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: Appointment.self)
                } ?? []
            }
    }
}
