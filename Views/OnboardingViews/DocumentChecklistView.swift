//
//  DocumentChecklistView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 05/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import AlertToast
import FirebaseAuth
import SwiftUICore

struct DocumentChecklistView: View {
    
    @State private var showPicker = false
    @State private var uploadedFileURL: String?
    @State private var showSuccess = false
    @State private var isUploading = false
    @State private var selectedDocumentType: String = "Other"  // You can wire this to a Picker if needed
    
<<<<<<< HEAD
       // MARK: - UI Constants
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

=======
    
       // MARK: - UI Constants
       private let primaryColor = Color(red: 0.07, green: 0.36, blue: 0.65)  // Deep UK blue
       private let accentColor = Color(red: 0.94, green: 0.35, blue: 0.15)   // UK accent orange
       private let backgroundColor = Color(red: 0.96, green: 0.96, blue: 0.98)
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
    
    var onFinish: () -> Void = {}
    
    var body: some View {
            VStack(spacing: 25) {
                // Header
                VStack(spacing: 15) {
                    Image(systemName: "doc.on.doc.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(primaryColor)
                    
                    Text("Upload Required Documents")
                        .font(.title2)
                        .bold()
                        .foregroundColor(primaryColor)
                        .multilineTextAlignment(.center)
                    
                    Text("Please upload the required documents to complete your application")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                // Document Type Picker
                VStack(alignment: .leading, spacing: 10) {
                    Text("Document Type")
                        .font(.headline)
                        .foregroundColor(primaryColor)
                    
                    Picker("Document Type", selection: $selectedDocumentType) {
                        Text("Identification").tag("ID")
                        Text("Proof of Address").tag("Address")
                        Text("Application Form").tag("Application")
                        Text("Other").tag("Other")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding(.horizontal)
                
                // Upload Section
                if isUploading {
                    VStack(spacing: 20) {
                        ProgressView("Uploading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                        
                        Text("Please wait while we upload your document")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(40)
                } else {
                    Button(action: { showPicker = true }) {
                        VStack(spacing: 15) {
                            Image(systemName: "arrow.up.doc.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(primaryColor)
                            
                            Text("Select Document to Upload")
                                .font(.headline)
                                .foregroundColor(primaryColor)
                            
                            Text("PDF, JPG, or PNG files (Max 10MB)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(30)
                        .background(Color.white)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(primaryColor.opacity(0.3), lineWidth: 2)
                        )
                    }
                }
                
                // Uploaded File
                if let url = uploadedFileURL, let fileURL = URL(string: url) {
                    HStack {
                        Image(systemName: "doc.fill")
                            .foregroundColor(primaryColor)
                        
                        Link("View Uploaded Document", destination: fileURL)
                            .font(.subheadline)
                            .foregroundColor(primaryColor)
                        
                        Spacer()
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Action Buttons
                HStack(spacing: 20) {
                    Button("Skip for Now") {
                        onFinish()
                    }
                    .font(.headline)
                    .foregroundColor(primaryColor)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(primaryColor, lineWidth: 1)
                    )
                    
                    Button("Continue") {
                        onFinish()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
<<<<<<< HEAD
                    .background(AppColors.primary)
=======
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(primaryColor)
                    .cornerRadius(12)
                    .shadow(color: primaryColor.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColor.ignoresSafeArea())
            .sheet(isPresented: $showPicker) {
                DocumentPicker { urls in
                    if let first = urls.first {
                        isUploading = true
                        // Simulate upload process
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            isUploading = false
                            uploadedFileURL = "https://example.com/uploaded_document.pdf"
                            showSuccess = true
                        }
                    }
                }
            }
            .alert(isPresented: $showSuccess) {
                Alert(
                    title: Text("Upload Successful"),
                    message: Text("Your document has been uploaded successfully"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
