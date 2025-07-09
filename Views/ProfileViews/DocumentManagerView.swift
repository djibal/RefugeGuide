//
//  DocumentManagerView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/07/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct DocumentManagerView: View {
    @State private var documents: [UserDocument] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading documents...")
                } else if documents.isEmpty {
                    Text("No documents found.")
                        .foregroundColor(.secondary)
                } else {
                    List {
                        ForEach(documents) { doc in
                            VStack(alignment: .leading) {
                                Text(doc.filename)
                                    .font(.headline)
                                Text("Uploaded: \(doc.uploadDate.formatted(.dateTime))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    deleteDocument(doc)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("My Documents")
            .alert("Error", isPresented: .constant(errorMessage != nil), actions: {
                Button("OK", role: .cancel) {}
            }, message: {
                Text(errorMessage ?? "")
            })
            .onAppear(perform: fetchDocuments)
        }
    }

    private func fetchDocuments() {
        guard let uid = Auth.auth().currentUser?.uid else {
            errorMessage = "Not logged in"
            return
        }

        let docRef = Firestore.firestore().collection("users").document(uid).collection("documents")
        docRef.getDocuments { snapshot, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }

            self.documents = snapshot?.documents.compactMap { doc in
                try? doc.data(as: UserDocument.self)
            } ?? []

            self.isLoading = false
        }
    }

    private func deleteDocument(_ doc: UserDocument) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let firestorePath = Firestore.firestore().collection("users").document(uid).collection("documents").document(doc.id)
        let storageRef = Storage.storage().reference(withPath: doc.storagePath)

        firestorePath.delete { error in
            if let error = error {
                self.errorMessage = "Failed to delete metadata: \(error.localizedDescription)"
                return
            }

            storageRef.delete { error in
                if let error = error {
                    self.errorMessage = "Failed to delete file: \(error.localizedDescription)"
                } else {
                    documents.removeAll { $0.id == doc.id }
                }
            }
        }
    }
}

// MARK: - UserDocument Model (renamed from UploadedDocument)
struct UserDocument: Identifiable, Codable {
    let id: String
    let filename: String
    let uploadDate: Date
    let storagePath: String
}
