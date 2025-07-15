//
//  PostCardView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 02/06/2025.
//

import SwiftUI
import Foundation
import FirebaseFunctions
import FirebaseFirestoreSwift
import FirebaseAuth
import SwiftUICore

struct PostCardView: View {
    @ObservedObject var viewModel: CommunityViewModel
    let post: CommunityPost
    
    @State private var showOptionsDialog = false
    @State private var showingDetail = false
    @State private var previewComments: [Comment] = []
    
    let primaryColor = Color(hex: "#0D3B66")  // Rich blue
    let accentColor = Color(hex: "#F95738")   // Bright coral-red
    let cardColor = Color(hex: "#FFFFFF")     // White
    let backgroundColor = Color(hex: "#F5F9FF") // Soft blue-white
    let textPrimary = Color(hex: "#1A1A1A")   // Neutral dark
    let textSecondary = Color(hex: "#555555") // Medium gray

    private var isLiked: Bool {
        guard let userID = Auth.auth().currentUser?.uid else { return false }
        return post.likedBy.contains(userID)
    }
    
    private var canDelete: Bool {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return false
        }
        return post.authorID == currentUserID
    }
    
    private var authorIconColor: Color {
        post.isAnonymous ? .gray : .accentColor
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(alignment: .top) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(authorIconColor)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(post.isAnonymous ? "Anonymous Refugee" : post.authorName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text(post.relativeTime)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(post.formattedDate)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Button {
                    showOptionsDialog = true
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            // Category Tag
            HStack {
                Text(post.category.localizedName)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(post.category.color.opacity(0.2))
                    .foregroundColor(post.category.color)
                    .cornerRadius(20)
                Spacer()
            }
            
            // Post Content
            VStack(alignment: .leading, spacing: 8) {
                Text(post.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(post.content)
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // IMPROVEMENT: Added a reply button to each comment preview.
            // This allows users to quickly navigate to the detail view to reply to a specific comment.
            // Comment Preview (Top 2)
            if !previewComments.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(previewComments) { comment in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(comment.isAnonymous ? "Anonymous" : comment.authorName)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                
                                if comment.content.starts(with: "@") {
                                    let parts = comment.content.split(separator: " ", maxSplits: 1)
                                    if parts.count == 2 {
                                        HStack(alignment: .top, spacing: 0) {
                                            Text(parts[0])
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.accentColor)
                                            Text(" " + parts[1])
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    } else {
                                        Text(comment.content)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                } else {
                                    Text(comment.content)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                            Button("Reply") {
                                showingDetail = true
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                        }
                    }
                }
                .padding(.top, 4)
            }
            
            // Footer Buttons
            HStack(spacing: 24) {
                Button(action: toggleLike) {
                    HStack(spacing: 4) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .secondary)
                        Text("\(post.likes)")
                    }
                    .font(.subheadline)
                }
                
                Button(action: {
                    showingDetail = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.left")
                        Text("Comment")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 16)
        .sheet(isPresented: $showingDetail) {
            PostDetailView(viewModel: viewModel, post: post)
        }
        .confirmationDialog("Post Options", isPresented: $showOptionsDialog) {
            if canDelete {
                Button("Delete Post", role: .destructive) {
                    viewModel.deletePost(post)
                }
            }
            
            Button("Report: Hate Speech") {
                viewModel.reportPost(post, reason: "Hate Speech")
            }
            Button("Report: Harassment") {
                viewModel.reportPost(post, reason: "Harassment")
            }
            Button("Report: False Information") {
                viewModel.reportPost(post, reason: "False Information")
            }
            Button("Cancel", role: .cancel) {}
        }
        .onAppear {
            guard let id = post.id else { return }
            viewModel.fetchPreviewComments(for: id) { comments in
                self.previewComments = comments
            }
        }
    }
    
    private func toggleLike() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        viewModel.toggleLike(for: post, userID: userID)
    }
}
