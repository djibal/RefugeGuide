//
//  MyDocumentsView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 14/06/2025.
import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import SwiftUICore

struct UploadedDoc: Identifiable {
    let id: String
    let fileName: String
    let downloadURL: URL
    let timestamp: Date
    let category: String
}

struct MyDocumentsView: View {
    @State private var documents: [UploadedDoc] = []
    @State private var filteredDocuments: [UploadedDoc] = []
    @State private var selectedCategory: String = NSLocalizedString("All", comment: "")
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")


    let documentCategories = [
        NSLocalizedString("All", comment: ""),
        NSLocalizedString("ARC (Asylum Registration Card)", comment: ""),
        NSLocalizedString("BRP (Biometric Residence Permit)", comment: ""),
        NSLocalizedString("Home Office Letter", comment: ""),
        NSLocalizedString("Court Document", comment: ""),
        NSLocalizedString("Travel Document", comment: ""),
        NSLocalizedString("Other", comment: "")
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(NSLocalizedString("Filter by Type", comment: ""))) {
                    Picker("", selection: $selectedCategory) {
                        ForEach(documentCategories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(.inline)
                    .onChange(of: selectedCategory) { _ in
                        applyFilter()
                    }
                }

                if isLoading {
                    ProgressView(NSLocalizedString("Loading your documents...", comment: ""))
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text("❌ \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if filteredDocuments.isEmpty {
                    Text(NSLocalizedString("No documents found for the selected type.", comment: ""))
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    Section(header: Text(NSLocalizedString("Documents", comment: ""))) {
                        ForEach(filteredDocuments) { doc in
                            Link(destination: doc.downloadURL) {
                                HStack(alignment: .top, spacing: 12) {
                                    let (icon, color) = iconAndColor(for: doc.category)

                                    Image(systemName: icon)
                                        .foregroundColor(color)
                                        .frame(width: 24)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(doc.fileName.removingPercentEncoding ?? doc.fileName)
                                            .font(.headline)

                                        Text(doc.category)
                                            .font(.caption)
                                            .foregroundColor(.secondary)

                                        Text(String(format: NSLocalizedString("Uploaded on %@", comment: ""), doc.timestamp.formatted(date: .abbreviated, time: .shortened)))
                                            .font(.caption2)
                                            .foregroundColor(AppColors.textSecondary)

                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteDocument)
                    }
                }
            }
            .navigationTitle(NSLocalizedString("My Documents", comment: ""))
            .onAppear(perform: fetchDocuments)
            .refreshable {
                fetchDocuments()
            }
        }
    }

    func fetchDocuments() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = NSLocalizedString("User not logged in.", comment: "")
            isLoading = false
            return
        }

        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("documents")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                isLoading = false
                if let error = error {
                    errorMessage = error.localizedDescription
                } else {
                    documents = snapshot?.documents.compactMap { doc in
                        let data = doc.data()
                        guard
                            let fileName = data["fileName"] as? String,
                            let urlStr = data["downloadURL"] as? String,
                            let url = URL(string: urlStr),
                            let timestamp = data["timestamp"] as? Timestamp
                        else {
                            return nil
                        }

                        let category = data["category"] as? String ?? NSLocalizedString("Other", comment: "")

                        return UploadedDoc(
                            id: doc.documentID,
                            fileName: fileName,
                            downloadURL: url,
                            timestamp: timestamp.dateValue(),
                            category: category
                        )
                    } ?? []
                    applyFilter()
                }
            }
    }

    func applyFilter() {
        if selectedCategory == NSLocalizedString("All", comment: "") {
            filteredDocuments = documents
        } else {
            filteredDocuments = documents.filter { $0.category == selectedCategory }
        }
    }

    func deleteDocument(at offsets: IndexSet) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        for index in offsets {
            let document = filteredDocuments[index]
            let db = Firestore.firestore()
            let storage = Storage.storage()

            db.collection("users")
                .document(userId)
                .collection("documents")
                .document(document.id)
                .delete()

            let storagePath = "uploads/\(document.fileName)"
            Task {
                do {
                    try await storage.reference(withPath: storagePath).delete()
                } catch {
                    print("❌ Failed to delete file from Storage: \(error.localizedDescription)")
                }
            }

            documents.removeAll { $0.id == document.id }
            applyFilter()
        }
    }

    func iconAndColor(for category: String) -> (icon: String, Color) {
        switch category {
        case "ARC (Asylum Registration Card)":
            return ("person.badge.shield.checkmark", .purple)
        case "BRP (Biometric Residence Permit)":
            return ("idcard", .blue)
        case "Home Office Letter":
            return ("envelope", .green)
        case "Court Document":
            return ("doc.text.fill", .red)
        case "Travel Document":
            return ("airplane", .orange)
        default:
            return ("doc", .gray)
        }
    }
}
