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
import SwiftUICore


private let cardBackground = Color.white


struct DashboardView: View {
    
    // MARK: - UI Constants
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

    
    var body: some View {
           ScrollView {
               VStack(spacing: 25) {
                   // Status Tracker
                   StatusTrackerView(currentPhase: .interview, primaryColor: primaryColor)
                       .padding()
                       .background(cardBackground)
                       .cornerRadius(15)
                       .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                   
                   // Appointments
                   AppointmentsListView(appointments: sampleAppointments, primaryColor: primaryColor)
                       .padding()
                       .background(cardBackground)
                       .cornerRadius(15)
                       .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                   
                   // Document Tasks
                   DocumentTaskView(primaryColor: primaryColor)
                       .padding()
                       .background(cardBackground)
                       .cornerRadius(15)
                       .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
               }
               .padding()
               .background(backgroundColor.ignoresSafeArea())
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
    let primaryColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                    .foregroundColor(primaryColor)
                
                Text("Application Status")
                    .font(.headline)
                    .foregroundColor(primaryColor)
            }
            
            ForEach(ApplicationPhase.allCases, id: \.self) { phase in
                HStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(phase == currentPhase ? primaryColor : Color.gray.opacity(0.2))
                            .frame(width: 24, height: 24)
                        
                        if phase == currentPhase {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Text(phase.rawValue)
                        .foregroundColor(phase == currentPhase ? primaryColor : .gray)
                    
                    Spacer()
                    
                    if phase == currentPhase {
                        Text("Current")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(primaryColor)
                            .cornerRadius(20)
                    }
                }
                .padding(.vertical, 5)
            }
        }
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
    let primaryColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(primaryColor)
                
                Text("Upcoming Appointments")
                    .font(.headline)
                    .foregroundColor(primaryColor)
            }
            .padding(.bottom, 10)
            
            ForEach(appointments) { appointment in
                HStack {
                    Circle()
                        .fill(primaryColor.opacity(0.1))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "clock")
                                .foregroundColor(primaryColor)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(appointment.title)
                            .font(.subheadline)
                            .bold()
                        Text(appointment.date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Details")
                            .font(.caption)
                            .bold()
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(primaryColor.opacity(0.1))
                            .foregroundColor(primaryColor)
                            .cornerRadius(20)
                    }
                }
                .padding(.vertical, 8)
                
                if appointment.id != appointments.last?.id {
                    Divider()
                }
            }
        }
    }
}

// MARK: - Document Task View
struct DocumentTaskView: View {
    @State private var showPicker = false
    @State private var uploadedFileName: String?
    @State private var uploadMessage: String?
    
    let primaryColor: Color

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
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: "checklist")
                        .foregroundColor(primaryColor)
                    
                    Text("Document Tasks")
                        .font(.headline)
                        .foregroundColor(primaryColor)
                }
                .padding(.bottom, 5)
                
                DocumentTaskButton(
                    icon: "doc.fill",
                    title: "Upload ID",
                    color: primaryColor,
                    action: { showPicker = true }
                )
                
                DocumentTaskButton(
                    icon: "mappin.and.ellipse",
                    title: "Confirm Address",
                    color: primaryColor,
                    action: {}
                )
                
                DocumentTaskButton(
                    icon: "envelope.fill",
                    title: "View Letter",
                    color: primaryColor,
                    action: {}
                )
                
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
                // ... rest of existing code ...
            
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

struct DocumentTaskButton: View {
        let icon: String
        let title: String
        let color: Color
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(color)
                    
                    Text(title)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(AppColors.textSecondary)

                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            }
        }
    }
    

