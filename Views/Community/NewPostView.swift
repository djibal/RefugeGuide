//
//  NewPostView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 19/06/2025.
//
<<<<<<< HEAD
import SwiftUI
import Foundation
import FirebaseFunctions
import FirebaseFirestoreSwift
=======


import Foundation
import SwiftUI
import FirebaseFunctions
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf
import FirebaseAuth
import SwiftUICore

struct NewPostView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CommunityViewModel
    @State private var postTitle = ""
    @State private var postContent = ""
    @State private var isAnonymous = true
    @State private var selectedCategory: CommunityPost.Category = .general
    @State private var isPosting = false
    @FocusState private var isContentFocused: Bool
    
    let primaryColor = Color(hex: "#0D3B66")  // Rich blue
    let accentColor = Color(hex: "#F95738")   // Bright coral-red
    let cardColor = Color(hex: "#FFFFFF")     // White
    let backgroundColor = Color(hex: "#F5F9FF") // Soft blue-white
    let textPrimary = Color(hex: "#1A1A1A")   // Neutral dark
    let textSecondary = Color(hex: "#555555") // Medium gray

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("Post Details", comment: "Section header for post details"))) {
                    TextField(NSLocalizedString("Title (required)", comment: "Placeholder for post title"), text: $postTitle)
                        .font(.headline)
                    
                    Picker(NSLocalizedString("Category", comment: "Picker label for post category"), selection: $selectedCategory) {
                        ForEach(CommunityPost.Category.allCases, id: \.self) { category in
                            Label(category.localizedName, systemImage: category.iconName)
                                .tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Toggle(isOn: $isAnonymous) {
                        Label(NSLocalizedString("Post Anonymously", comment: "Label for anonymous posting toggle"), systemImage: "eye.slash")
                    }
                }
                
                Section(header: Text(NSLocalizedString("Your Message", comment: "Section header for post content"))) {
                    ZStack(alignment: .topLeading) {
                        if postContent.isEmpty {
                            Text(NSLocalizedString("Share your thoughts, questions, or experiences...", comment: "Placeholder for post content text editor"))
                                .foregroundColor(AppColors.textSecondary)
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        
                        TextEditor(text: $postContent)
                            .frame(minHeight: 150)
                            .focused($isContentFocused)
                    }
                }
                
                Section {
                    Button(action: createPost) {
                        HStack {
                            Spacer()
                            if isPosting {
                                ProgressView()
                            } else {
                                Image(systemName: "paperplane.fill")
                                Text(NSLocalizedString("Share Post", comment: "Button label to share a post"))
                                    .bold()
                            }
                            Spacer()
                        }
                        .padding()
                        .background(postTitle.isEmpty || postContent.isEmpty ? Color.gray : Color.accentColor)
                        .foregroundColor(.white)
                        .background(AppColors.primary)
                        .cornerRadius(12)
                    }
                    .disabled(postTitle.isEmpty || postContent.isEmpty || isPosting)
                }
            }
            .navigationTitle(NSLocalizedString("New Post", comment: "Navigation title for new post view"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("Cancel", comment: "Button label to cancel an action")) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func createPost() {
        isPosting = true
        let authorName = Auth.auth().currentUser?.displayName ?? "Refugee User"
        
        viewModel.createPost(
            title: postTitle,
            content: postContent,
            isAnonymous: isAnonymous,
            authorName: authorName,
            category: selectedCategory
        ) {
            isPosting = false
            dismiss()
        }
    }
}
