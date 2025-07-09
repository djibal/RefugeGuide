
//  PostCardView.swift
//  RefugeGuide
//
//    Created by Djibal Ramazani on 02/06/2025.
//

import SwiftUI
import FirebaseAuth

struct PostCardView: View {
    @ObservedObject var viewModel: CommunityViewModel
    let post: CommunityPost
    @State private var showReportDialog = false
    @State private var reportReason = ""
    
    private var isLiked: Bool {
        guard let userID = Auth.auth().currentUser?.uid else { return false }
        return post.likedBy.contains(userID)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerSection
            
            Text(post.content)
                .font(.body)
                .padding(.vertical, 8)
            
            footerSection
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .contextMenu {
            Button {
                showReportDialog = true
            } label: {
                Label("Report Post", systemImage: "exclamationmark.bubble")
            }
        }
        .confirmationDialog("Report Post", isPresented: $showReportDialog) {
            reportOptionsDialog
        }
    }
    
    private var headerSection: some View {
        HStack {
            if post.isAnonymous {
                Image(systemName: "person.crop.circle.fill")
                    .font(.title)
                    .foregroundColor(.gray)
                Text("Anonymous Refugee")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .font(.title)
                    .foregroundColor(.accentColor)
                Text(post.authorName)
                    .font(.subheadline)
                    .bold()
            }
            
            Spacer()
            
            Text(post.timestamp, style: .relative)
                .font(.caption)
                .foregroundColor(.secondary)
                + Text(" ago")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var footerSection: some View {
        HStack(spacing: 20) {
            Button(action: toggleLike) {
                HStack(spacing: 4) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : .secondary)
                    Text("\(post.likes)")
                        .foregroundColor(.secondary)
                }
            }
            
            Button(action: { /* Implement comment functionality */ }) {
                HStack(spacing: 4) {
                    Image(systemName: "bubble.left")
                    Text("12") // Placeholder
                }
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(post.category.rawValue.capitalized)
                .font(.caption)
                .padding(6)
                .background(Color.accentColor.opacity(0.1))
                .cornerRadius(8)
        }
        .buttonStyle(.borderless)
    }
    
    private var reportOptionsDialog: some View {
        VStack {
            Button("Hate Speech") { viewModel.reportPost(post, reason: "Hate Speech") }
            Button("Harassment") { viewModel.reportPost(post, reason: "Harassment") }
            Button("False Information") { viewModel.reportPost(post, reason: "False Information") }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    private func toggleLike() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        viewModel.toggleLike(for: post, userID: userID)
    }
}
