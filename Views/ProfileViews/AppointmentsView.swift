//
//  AppointmentsView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AppointmentsView: View {
    @State private var appointments: [Appointment] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

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
