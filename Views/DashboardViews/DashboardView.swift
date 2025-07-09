//
//  DashboardView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers
import FirebaseStorage


struct DashboardView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                StatusTrackerView(currentPhase: .interview)
                AppointmentsListView(appointments: sampleAppointments)
                DocumentTaskView()
            }
            .padding()
        }
        .navigationTitle("My Dashboard")
    }
}

// MARK: - Application Phase Enum
enum ApplicationPhase: String, CaseIterable {
    case screening = "Screening Complete"
    case interview = "Awaiting Substantive Interview"
    case decision = "Decision Pending"
    case outcome = "Outcome Issued"
}

// MARK: - Status Tracker View
struct StatusTrackerView: View {
    let currentPhase: ApplicationPhase

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Application Status")
                .font(.headline)
            ForEach(ApplicationPhase.allCases, id: \.self) { phase in
                HStack {
                    Circle()
                        .fill(phase == currentPhase ? Color.blue : Color.gray.opacity(0.4))
                        .frame(width: 16, height: 16)
                    Text(phase.rawValue)
                        .foregroundColor(phase == currentPhase ? .blue : .gray)
                }
            }
        }
        .padding(.vertical)
    }
}

// MARK: - Appointment Model & View
struct MyAppointment: Identifiable {
    let id = UUID()
    let title: String
    let date: String
}

let sampleAppointments = [
    MyAppointment(title: "BRP Appointment", date: "3 June 2025"),
    MyAppointment(title: "Legal Interview", date: "5 June 2025")
]

struct AppointmentsListView: View {
    var appointments: [MyAppointment]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Upcoming Appointments")
                .font(.headline)
            ForEach(appointments) { appointment in
                HStack {
                    Text(appointment.title)
                    Spacer()
                    Text(appointment.date)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
    }
}

// MARK: - Document Task View
struct DocumentTaskView: View {
    @State private var showPicker = false
    @State private var uploadedFileName: String?
    @State private var uploadMessage: String?

    func uploadFileToFirebase(fileURL: URL) {
        let storageRef = Storage.storage().reference().child("uploads/\(fileURL.lastPathComponent)")
        let uploadTask = storageRef.putFile(from: fileURL, metadata: nil) { metadata, error in
            if let error = error {
                print("❌ Upload failed: \(error.localizedDescription)")
                uploadMessage = "Upload failed."
                return
            }
            uploadMessage = "✅ Upload successful!"
            print("✅ Uploaded to Firebase: \(fileURL.lastPathComponent)")
        }

        uploadTask.observe(.progress) { snapshot in
            let percent = Double(snapshot.progress?.fractionCompleted ?? 0)
            print("Uploading: \(Int(percent * 100))%")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Tasks").font(.headline)

            Button("Upload ID") {
                showPicker = true
            }

            Button("Confirm Address") { }
            Button("View Letter") { }

            if let msg = uploadMessage {
                Text(msg)
                    .font(.subheadline)
                    .foregroundColor(msg.contains("✅") ? .green : .red)
            }

            if let name = uploadedFileName {
                Text("Uploaded: \(name)")
                    .font(.subheadline)
                    .foregroundColor(.green)
            }
        }
        .sheet(isPresented: $showPicker) {
            DocumentPicker { urls in
                if let first = urls.first {
                    uploadedFileName = first.lastPathComponent
                    uploadFileToFirebase(fileURL: first)
                }
            }
        }
        .padding(.vertical)
    }
}

// MARK: - Document Picker
struct DocumentPicker: UIViewControllerRepresentable {
    var onDocumentsPicked: ([URL]) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onDocumentsPicked: onDocumentsPicked)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let supportedTypes: [UTType] = [.item]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let onDocumentsPicked: ([URL]) -> Void

        init(onDocumentsPicked: @escaping ([URL]) -> Void) {
            self.onDocumentsPicked = onDocumentsPicked
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            onDocumentsPicked(urls)
        }
    }
}
