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
    @State private var showSuccess = false
    @State private var isUploading = false
    @State private var selectedDocumentType: String = "Other"  // You can wire this to a Picker if needed
    
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
        .sheet(isPresented: $showPicker, content: {
            DocumentPickerView { selectedURL in
                isUploading = true
                
                FileUploader.shared.uploadFile(
                    url: selectedURL,
                    progressHandler: { _ in },
                    completion: { result in
                        DispatchQueue.main.async {
                            isUploading = false
                            
                            switch result {
                            case .success(let (downloadURL, contentType)):
                                self.uploadedFileURL = downloadURL.absoluteString
                                self.showSuccess = true
                                
                                let fileName = selectedURL.lastPathComponent
                                
                                DocumentUploader.shared.saveDocumentMetadata(
                                    fileName: fileName,
                                    downloadURL: downloadURL,
                                    contentType: contentType,
                                    documentType: UKDocumentType(rawValue: selectedDocumentType) ?? .other
                                ) { result in
                                    if case .failure(let error) = result {
                                        print("❌ Metadata save failed: \(error.localizedDescription)")
                                    }
                                }

                                
                            case .failure(let error):
                                print("❌ Upload failed: \(error.localizedDescription)")
                            }
                        }
                    }
                )
            }
            .toast(isPresenting: $showSuccess) {
                AlertToast(type: .complete(Color.green), title: "Upload Successful")
            }
        })
    }
}
