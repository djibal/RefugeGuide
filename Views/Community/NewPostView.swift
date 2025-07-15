//
//  NewPostView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 19/06/2025.
//


import Foundation
import SwiftUI
import FirebaseFunctions
import FirebaseAuth

struct NewPostView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CommunityViewModel
    @State private var postContent = ""
    @State private var isAnonymous = true
    @State private var selectedCategory: CommunityPost.Category = .general
    @State private var isPosting = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Your Post")) {
                    TextEditor(text: $postContent)
                        .frame(minHeight: 150)
                        .accessibilityLabel("Post content")
                }
                
                Section(header: Text("Privacy")) {
                    Toggle("Post Anonymously", isOn: $isAnonymous)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                }
                
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(CommunityPost.Category.allCases, id: \.self) { category in
                            Text(category.rawValue.capitalized).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section {
                    Button(action: createPost) {
                        HStack {
                            Spacer()
                            if isPosting {
                                ProgressView()
                            } else {
                                Text("Share Post")
                                    .bold()
                            }
                            Spacer()
                        }
                    }
                    .disabled(postContent.isEmpty || isPosting)
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
        
        let authorName: String
        if let currentUser = Auth.auth().currentUser {
            authorName = currentUser.displayName ?? "Refugee User"
        } else {
            authorName = "Refugee User"
        }
        
        viewModel.createPost(
            content: postContent,
            isAnonymous: isAnonymous,
            authorName: authorName,
            category: selectedCategory
        ) {
            dismiss()
        }
    }
}
