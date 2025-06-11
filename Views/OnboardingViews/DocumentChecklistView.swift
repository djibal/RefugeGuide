//
//  DocumentChecklistView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 05/06/2025.
//

import SwiftUI
import AlertToast
import FirebaseAuth

struct DocumentChecklistView: View {
    
    @State private var showPicker = false
    @State private var uploadedFileURL: String?
    @State private var showSuccess = false // ✅ Make sure this exists!
    @State private var isUploading = false
    
    
    var onFinish: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Upload required documents")
            
            if isUploading {
                ProgressView("Uploading...")
                    .padding()
            } else {
                Button("Upload Document") {
                    showPicker = true
                }
                
                if let url = uploadedFileURL, let fileURL = URL(string: url) {
                    Link("Open Uploaded File", destination: fileURL)
                }
            }
        }
        .sheet(isPresented: $showPicker) {
            DocumentPickerView { selectedURL in
                isUploading = true
                
                FileUploader.shared.uploadFile(url: selectedURL) { result in
                    DispatchQueue.main.async {
                        isUploading = false
                        
                        switch result {
                        case .success(let downloadURLString):
                            self.uploadedFileURL = downloadURLString

                            // ✅ Optional reset after upload
                            self.uploadedFileURL = nil
                            self.showSuccess = true

                            let fileName = selectedURL.lastPathComponent
                            let contentType = "application/pdf"
                            
                            if let downloadURL = URL(string: downloadURLString) {
                                print("📤 Saving document for user ID: \(Auth.auth().currentUser?.uid ?? "nil")")

                                DocumentUploader.shared.saveDocumentMetadata(
                                    fileName: fileName,
                                    downloadURL: downloadURL,
                                    contentType: contentType
                                ) { error in
                                    if let error = error {
                                        print("❌ Firestore save failed: \(error.localizedDescription)")
                                    } else {
                                        print("✅ Firestore metadata saved")
                                    }
                                }
                            }
                            
                        case .failure(let error):
                            print("Upload failed: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
        .toast(isPresenting: $showSuccess) {
            AlertToast(type: .complete(Color.green), title: "Upload Successful")
         }
       }
    }
