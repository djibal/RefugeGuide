//
//  UploadDocumentView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 14/06/2025.
//
import SwiftUI
import FirebaseFirestore
import UniformTypeIdentifiers
import FirebaseAuth
import SwiftUICore

struct UploadDocumentView: View {
    @State private var selectedFileURL: URL?
    @State private var selectedCategory = "Other"
    @State private var isUploading = false
    @State private var uploadSuccess = false
    @State private var uploadError: String?
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")


    let documentCategories = [
        "ARC (Asylum Registration Card)",
        "BRP (Biometric Residence Permit)",
        "Home Office Letter",
        "Court Document",
        "Travel Document",
        "Other"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Select Document Type")) {
                    Picker("Document Type", selection: $selectedCategory) {
                        ForEach(documentCategories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }

                    .pickerStyle(.inline)
                }

                Section(header: Text("Attach File")) {
                    if let fileURL = selectedFileURL {
                        HStack {
                            Image(systemName: "doc.fill")
                                .foregroundColor(.blue)
                            Text(fileURL.lastPathComponent)
                                .font(.subheadline)
                                .lineLimit(1)
                        }
                    } else {
                        Text("No file selected")
                            .foregroundColor(AppColors.textSecondary)

                    }

                    Button("Choose File") {
                        presentFilePicker()
                    }
                }

                if selectedFileURL != nil {
                    Section {
                        Button(action: uploadDocument) {
                            HStack {
                                Spacer()
                                if isUploading {
                                    ProgressView()
                                } else {
                                    Text("Upload Document")
                                        .bold()
                                }
                                Spacer()
                            }
                        }
                        .disabled(isUploading)
                    }
                }

                if uploadSuccess {
                    Section {
                        Label("\u{2705} Upload Successful!", systemImage: "checkmark.seal.fill")
                            .foregroundColor(.green)
                    }
                }

                if let error = uploadError {
                    Section {
                        Text("\u{274C} \(error)")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Upload Document")
        }
    }

    func uploadDocument() {
        guard let url = selectedFileURL else { return }
        isUploading = true
        uploadError = nil
        uploadSuccess = false

        FileUploader.shared.uploadFile(
            url: url,
            progressHandler: { _ in },
            completion: { result in
                DispatchQueue.main.async {
                    isUploading = false
                    switch result {
                    case .success(let (downloadURL, contentType)):
                        let fileName = url.lastPathComponent
                        let metadata: [String: Any] = [
                            "fileName": fileName,
                            "downloadURL": downloadURL.absoluteString,
                            "contentType": contentType,
                            "timestamp": Timestamp(date: Date()),
                            "category": selectedCategory
                        ]

                        guard let userId = Auth.auth().currentUser?.uid else {
                            uploadError = "User not authenticated"
                            return
                        }

                        Firestore.firestore()
                            .collection("users")
                            .document(userId)
                            .collection("documents")
                            .addDocument(data: metadata) { error in
                                if let error = error {
                                    uploadError = "Error saving metadata: \(error.localizedDescription)"
                                } else {
                                    uploadSuccess = true
                                    selectedFileURL = nil
                                }
                            }

                    case .failure(let error):
                        uploadError = "Upload failed: \(error.localizedDescription)"
                    }
                }
            }
        )
    }

    func presentFilePicker() {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item])
        picker.allowsMultipleSelection = false

        let delegate = DocumentPickerDelegateWrapper { url in
            self.selectedFileURL = url
        }
        picker.delegate = delegate

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(picker, animated: true)
        }
    }

    class DocumentPickerDelegateWrapper: NSObject, UIDocumentPickerDelegate {
        let completion: (URL?) -> Void

        init(completion: @escaping (URL?) -> Void) {
            self.completion = completion
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            completion(urls.first)
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            completion(nil)
        }
    }
}
