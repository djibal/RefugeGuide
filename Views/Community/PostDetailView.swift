//
//  PostDetailView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 16/07/2025.
//

import SwiftUI
import Foundation
import FirebaseFunctions
import FirebaseFirestoreSwift
import FirebaseAuth
import SwiftUICore

// IMPROVEMENT: Added a dismiss environment variable to programmatically close the view after deletion.
// IMPROVEMENT: Added state to control the presentation of a delete confirmation dialog.
struct PostDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CommunityViewModel
    let post: CommunityPost

    @State private var comments: [Comment] = []
    @State private var newComment = ""
    @State private var isAnonymous = true
    @State private var showDeleteConfirmation = false
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let cardColor = Color(hex: "#FFFFFF")
    let backgroundColor = Color(hex: "#F5F9FF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

    // IMPROVEMENT: This computed property checks if the current user is the author of the post.
    // It ensures that the delete button is only visible to the user who created the post.
    private var canDelete: Bool {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return false
        }
        return post.authorID == currentUserID
    }

    var body: some View {
        List {
            // Post Header
            Section {
                PostCardView(viewModel: viewModel, post: post)
                    .listRowInsets(EdgeInsets())
            }

            // Comments Section
            Section(header: Text("Comments (\(comments.count))")) {
                ForEach(comments) { comment in
                    CommentView(comment: comment) { mention in
                        newComment = mention
                    }
                }

                // Add New Comment
                VStack(spacing: 8) {
                    TextField("Add a comment...", text: $newComment)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.send)

                    Toggle("Post Anonymously", isOn: $isAnonymous)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))

                    Button(action: addComment) {
                        HStack {
                            Spacer()
                            Image(systemName: "paperplane.fill")
                            Text("Send")
                                .bold()
                            Spacer()
                        }
                        .padding()
                        .background(newComment.isEmpty ? Color.gray.opacity(0.3) : Color.accentColor)
                        .foregroundColor(.white)
                        .background(AppColors.primary)
                        .cornerRadius(10)
                    }
                    .disabled(newComment.isEmpty)
                }
                .padding(.top, 8)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Post Details")
        .navigationBarTitleDisplayMode(.inline)
        // IMPROVEMENT: Added a toolbar with a delete button that is only visible to the post's author.
        // This provides a clear and accessible way for users to delete their own content.
        .toolbar {
            if canDelete {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        // IMPROVEMENT: Added a confirmation dialog to prevent accidental deletions.
        // This improves the user experience by giving them a chance to confirm their action.
        .confirmationDialog("Are you sure you want to delete this post?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive, action: deletePost)
        }
        .onAppear {
            viewModel.fetchComments(for: post.id ?? "") { fetchedComments in
                comments = fetchedComments
            }
        }
    }

    private func addComment() {
        viewModel.addComment(to: post.id ?? "", content: newComment, isAnonymous: isAnonymous) {
            newComment = ""
            viewModel.fetchComments(for: post.id ?? "") { fetchedComments in
                comments = fetchedComments
            }
        }
    }

    // IMPROVEMENT: This function calls the view model's deletePost method and dismisses the view upon completion.
    // This ensures a smooth user flow after a post is deleted.
    private func deletePost() {
        viewModel.deletePost(post) {
            dismiss()
        }
    }
}

struct CommentView: View {
    let comment: Comment
    var onReply: ((String) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(comment.isAnonymous ? "Anonymous" : comment.authorName)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Spacer()

                Text(comment.relativeTime)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            // Format @mention if present
            if comment.content.starts(with: "@") {
                let parts = comment.content.split(separator: " ", maxSplits: 1)
                if parts.count == 2 {
                    Text(parts[0]) // @username
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.accentColor)
                    Text(parts[1]) // rest of comment
                        .font(.body)
                } else {
                    Text(comment.content)
                        .font(.body)
                }
            } else {
                Text(comment.content)
                    .font(.body)
            }

            Button("Reply") {
                onReply?("@\(comment.authorName) ")
            }
            .font(.caption)
            .foregroundColor(.blue)
            .padding(.top, 4)
        }
        .padding(.vertical, 6)
    }
}
