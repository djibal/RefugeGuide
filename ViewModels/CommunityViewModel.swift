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
import SwiftUICore

class CommunityViewModel: ObservableObject {
    @Published var posts: [CommunityPost] = []
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var showError = false

    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()

    // MARK: - Init

    init(posts: [CommunityPost] = []) {
        self.posts = posts
    }

    // MARK: - Fetch Posts

    func fetchPosts() {
        isLoading = true
        listener?.remove()
        listener = db.collection("communityPosts")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                self.isLoading = false

                if let error = error {
                    self.showError(message: "Error loading posts: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                self.posts = documents.compactMap { doc in
                    try? doc.data(as: CommunityPost.self)
                }
            }
    }

    // MARK: - Create Post

    func createPost(title: String, content: String, isAnonymous: Bool, authorName: String, category: CommunityPost.Category, completion: @escaping () -> Void) {
        guard !title.isEmpty, !content.isEmpty else {
            showError(message: "Title and content cannot be empty")
            return
        }
        guard let userID = Auth.auth().currentUser?.uid else {
            showError(message: "Authentication required")
            return
        }

        let postRef = db.collection("communityPosts").document()
        let post = CommunityPost(
            id: postRef.documentID,
            title: title,
            content: content,
            category: category,
            authorID: userID,
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

    // MARK: - Delete Post

    // IMPROVEMENT: Added a completion handler to notify the caller when the deletion is successful.
    // This is crucial for updating the UI after a post is deleted, for instance, by dismissing a view.
    func deletePost(_ post: CommunityPost, completion: (() -> Void)? = nil) {
        guard let postID = post.id else { return }
        guard let userID = Auth.auth().currentUser?.uid else {
            showError(message: "Authentication required")
            return
        }

        if post.authorID == userID {
            db.collection("communityPosts").document(postID).delete { error in
                if let error = error {
                    self.showError(message: "Failed to delete post: \(error.localizedDescription)")
                } else {
                    completion?()
                }
            }
        } else {
            showError(message: "You can only delete your own posts")
        }
    }

    // MARK: - Report Post

    func reportPost(_ post: CommunityPost, reason: String) {
        guard let postID = post.id else { return }

        db.collection("communityPosts").document(postID).updateData([
            "isReported": true,
            "reportReason": reason
        ]) { error in
            if let error = error {
                self.showError(message: "Report failed: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Add Comment

    func addComment(to postID: String, content: String, isAnonymous: Bool, completion: @escaping () -> Void) {
        guard !content.isEmpty else { return }
        guard let user = Auth.auth().currentUser else {
            showError(message: "Authentication required")
            return
        }

        let commentRef = db.collection("communityPosts").document(postID).collection("comments").document()
        let comment = Comment(
            id: commentRef.documentID,
            postID: postID,
            authorID: user.uid,
            authorName: isAnonymous ? "Anonymous Refugee" : (user.displayName ?? "Refugee User"),
            content: content,
            timestamp: Date(),
            isAnonymous: isAnonymous
        )


        do {
            try commentRef.setData(from: comment)
            completion()
        } catch {
            showError(message: "Failed to add comment: \(error.localizedDescription)")
        }
    }

    // MARK: - Fetch Comments

    func fetchComments(for postID: String, completion: @escaping ([Comment]) -> Void) {
        db.collection("communityPosts")
            .document(postID)
            .collection("comments")
            .order(by: "timestamp", descending: false)
            .getDocuments { snapshot, error in
                if let error = error {
                    self.showError(message: "Error loading comments: \(error.localizedDescription)")
                    completion([])
                    return
                }

                let comments = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: Comment.self)
                } ?? []

                completion(comments)
            }
    }
    
    func fetchPreviewComments(for postID: String, completion: @escaping ([Comment]) -> Void) {
        db.collection("communityPosts")
            .document(postID)
            .collection("comments")
            .order(by: "timestamp", descending: false)
            .limit(to: 2)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Preview comment fetch error: \(error.localizedDescription)")
                    completion([])
                    return
                }

                let comments = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: Comment.self)
                } ?? []

                completion(comments)
            }
    }

    // MARK: - Like Toggle

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
                likedBy.removeAll { $0 == userID }
                likes = max(0, likes - 1)
            } else {
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

    // MARK: - Error Helper

    func showError(message: String) {
        errorMessage = message
        showError = true
    }

    // MARK: - Cleanup

    deinit {
        listener?.remove()
    }
}

#if DEBUG
extension CommunityViewModel {
    static var mock: CommunityViewModel {
        let vm = CommunityViewModel()
        vm.posts = CommunityPost.samplePosts
        return vm
    }
}
#endif
