import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

struct UploadedDocument: Identifiable {
    let id: String
    let fileName: String
    let downloadURL: URL
    let timestamp: Date
}

struct DocumentsView: View {
    @State private var documents: [UploadedDocument] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView("Loading your documents...")
                } else if let errorMessage = errorMessage {
                    Text("❌ \(errorMessage)").foregroundColor(.red)
                } else if documents.isEmpty {
                    VStack {
                        Text("You haven’t uploaded any documents yet.")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                    }
                } else {
                    List(documents) { doc in
                        Link(destination: doc.downloadURL) {
                            VStack(alignment: .leading) {
                                Text(doc.fileName)
                                    .font(.headline)
                                Text("Uploaded on \(doc.timestamp.formatted(date: .abbreviated, time: .shortened))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("My Documents")
            .onAppear(perform: fetchDocuments)
        }
    }

    func fetchDocuments() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "User not logged in."
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

                        return UploadedDocument(
                            id: doc.documentID,
                            fileName: fileName,
                            downloadURL: url,
                            timestamp: timestamp.dateValue()
                        )
                    } ?? []
                }
            }
    }
}
