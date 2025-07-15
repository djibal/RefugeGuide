//
//  NewPostView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 19/06/2025.
//
import SwiftUI
import Foundation
import FirebaseFunctions
import FirebaseFirestoreSwift
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
                Section(header: Text("Post Details")) {
                    TextField("Title (required)", text: $postTitle)
                        .font(.headline)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(CommunityPost.Category.allCases, id: \.self) { category in
                            Label(category.localizedName, systemImage: category.iconName)
                                .tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Toggle(isOn: $isAnonymous) {
                        Label("Post Anonymously", systemImage: "eye.slash")
                    }
                }
                
                Section(header: Text("Your Message")) {
                    ZStack(alignment: .topLeading) {
                        if postContent.isEmpty {
                            Text("Share your thoughts, questions, or experiences...")
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
                                Text("Share Post")
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
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
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
