//
//  BookAppointmentView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SwiftUICore

struct BookAppointmentView: View {
    @State private var selectedDate = Date()
    @State private var appointmentType = "Legal Aid"
    @State private var notes = ""
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    @Environment(\.dismiss) var dismiss
    
    
    let primaryColor = Color(hex: "#0D3B66")  // Rich blue
    let accentColor = Color(hex: "#F95738")   // Bright coral-red
    let cardColor = Color(hex: "#FFFFFF")     // White
    let backgroundColor = Color(hex: "#F5F9FF") // Soft blue-white
    let textPrimary = Color(hex: "#1A1A1A")   // Neutral dark
    let textSecondary = Color(hex: "#555555") // Medium gray

    let appointmentTypes = [
        "Legal Aid",
        "Health Check",
        "Housing Support",
        "Asylum Case Follow-Up"
    ]

    var body: some View {
        Form {
            Section(header: Text("Appointment Type")) {
                Picker("Type", selection: $appointmentType) {
                    ForEach(appointmentTypes, id: \.self) { type in
                        Text(type)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }

            Section(header: Text("Select Date & Time")) {
                DatePicker("Appointment Date", selection: $selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
            }

            Section(header: Text("Additional Notes")) {
                TextEditor(text: $notes)
                    .frame(minHeight: 80)
            }

            Button(action: bookAppointment) {
                if isSubmitting {
                    ProgressView()
                } else {
                    Text("Book Appointment")
                }
            }
        }
        .navigationTitle("Book Appointment")
        .alert("Error", isPresented: .constant(errorMessage != nil), actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text(errorMessage ?? "")
        })
    }

    private func bookAppointment() {
        guard let uid = Auth.auth().currentUser?.uid else {
            errorMessage = "Not logged in"
            return
        }

        isSubmitting = true

        let appointment = [
            "type": appointmentType,
            "notes": notes,
            "scheduledAt": Timestamp(date: selectedDate),
            "createdAt": Timestamp(date: Date())
        ] as [String : Any]

        Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("appointments")
            .addDocument(data: appointment) { error in
                isSubmitting = false
                if let error = error {
                    self.errorMessage = "Failed to book: \(error.localizedDescription)"
                } else {
                    dismiss()
                }
            }
    }
}
