//
//  CommunityViewModel.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 29/06/2025.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import Combine

class CommunityViewModel: ObservableObject {
    @Published var urgentResources: [HelpResource] = []
    @Published var posts: [CommunityPost] = []
    @Published var isLoading = false
    @Published var postTitle: String = ""
    @Published var errorMessage = ""
    @Published var showError = false
    
    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()
    
    // For previews
    init(posts: [CommunityPost] = []) {
        self.posts = posts
    }
    
    func fetchPosts() {
        isLoading = true
        listener = db.collection("communityPosts")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    self.showError(message: "Error loading posts: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    return
                }
                
                self.posts = documents.compactMap { doc in
                    try? doc.data(as: CommunityPost.self)
                }
            }
    }
    
    func createPost(content: String, isAnonymous: Bool, authorName: String, category: CommunityPost.Category, completion: @escaping () -> Void) {
        guard !content.isEmpty else { return }
        guard let userID = Auth.auth().currentUser?.uid else {
            showError(message: "Authentication required")
            return
        }
        
        let postRef = db.collection("communityPosts").document()
        let post = CommunityPost(
            id: postRef.documentID,
            title: postTitle,
            content: content,
            category: category,
            authorName: isAnonymous ? "Anonymous Refugee" : authorName,
            timestamp: Date(),
            isAnonymous: isAnonymous
        )

        
        do {
            try postRef.setData(from: post)
            completion()
        } catch {
            showError(message: "Failed to create post: \(error.localizedDescription)")
        }
    }
    
    func reportPost(_ post: CommunityPost, reason: String) {
        guard let postID = post.id else { return }
        
        db.collection("communityPosts").document(postID).updateData([
            "isReported": true,
            "reportReason": reason
        ]) { error in
            if let error = error {
                self.showError(message: "Report failed: \(error.localizedDescription)")
            } else {
                // Optional: Show confirmation to user
            }
        }
    }
    
    func toggleLike(for post: CommunityPost, userID: String) {
        guard let postID = post.id else { return }
        
        let postRef = db.collection("communityPosts").document(postID)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let postDocument: DocumentSnapshot
            do {
                try postDocument = transaction.getDocument(postRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard var postData = postDocument.data() else {
                let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "Unable to retrieve post data"
                ])
                errorPointer?.pointee = error
                return nil
            }
            
            var likedBy = postData["likedBy"] as? [String] ?? []
            var likes = postData["likes"] as? Int ?? 0
            
            if likedBy.contains(userID) {
                // Unlike
                likedBy.removeAll { $0 == userID }
                likes = max(0, likes - 1)
            } else {
                // Like
                likedBy.append(userID)
                likes += 1
            }
            
            transaction.updateData([
                "likes": likes,
                "likedBy": likedBy
            ], forDocument: postRef)
            
            return nil
        }) { _, error in
            if let error = error {
                self.showError(message: "Like update failed: \(error.localizedDescription)")
            }
        }
    }
    
    func showError(message: String) {
        errorMessage = message
        showError = true
    }
    
    deinit {
        listener?.remove()
    }
}

#if DEBUG
extension CommunityViewModel {
    static var mock: CommunityViewModel {
        let vm = CommunityViewModel()
        vm.posts = CommunityPost.samplePosts // or []
        // ❌ vm.resources = [] ← REMOVE THIS LINE
        // ❌ vm.urgentResources = [] ← REMOVE if not defined
        return vm
    }
}
#endif
