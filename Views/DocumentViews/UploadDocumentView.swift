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

struct UploadDocumentView: View {
    @State private var selectedFileURL: URL?
    @State private var selectedCategory = "Other"
    @State private var isUploading = false
    @State private var uploadSuccess = false
    @State private var uploadError: String?

    // ✅ Keep a reference to prevent deallocation
    private var pickerDelegate = DocumentPickerDelegateWrapper { _ in }

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
            VStack(spacing: 24) {
                Text("Upload a Document")
                    .font(.title2)
                    .bold()

                Picker("Document Type", selection: $selectedCategory) {
                    ForEach(documentCategories, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                if let fileURL = selectedFileURL {
                    Text("📎 Selected: \(fileURL.lastPathComponent)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Button("Choose File") {
                    presentFilePicker()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

                if selectedFileURL != nil {
                    Button(action: uploadDocument) {
                        if isUploading {
                            ProgressView()
                        } else {
                            Text("Upload Document")
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }

                if uploadSuccess {
                    Label("✅ Upload Successful!", systemImage: "checkmark.seal.fill")
                        .foregroundColor(.green)
                        .padding(.top, 10)
                }

                if let error = uploadError {
                    Text("❌ \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Upload Document")
        }
    }

    func uploadDocument() {
        guard let url = selectedFileURL else { return }
        isUploading = true
        uploadError = nil
        uploadSuccess = false

        FileUploader.shared.uploadFile(url: url) { result in
            DispatchQueue.main.async {
                isUploading = false
                switch result {
                case .success(let (downloadURL, contentType)):
                    let fileName = url.lastPathComponent

                    // ✅ Include category as part of metadata
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
    }

    func presentFilePicker() {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item])
        picker.allowsMultipleSelection = false

        // ✅ Avoid deallocation
        pickerDelegate.completion = { url in
            self.selectedFileURL = url
        }
        picker.delegate = pickerDelegate

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(picker, animated: true)
        }
    }
}

// MARK: - Delegate Helper for UIDocumentPickerViewController
class DocumentPickerDelegateWrapper: NSObject, UIDocumentPickerDelegate {
    var completion: (URL?) -> Void

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
