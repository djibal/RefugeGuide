//
//  CommunityView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 29/06/2025.
//

import Foundation
import SwiftUI
import Foundation
import FirebaseFunctions
import FirebaseFirestoreSwift
import FirebaseAuth
import SwiftUICore

struct CommunityView: View {
    @StateObject var viewModel = CommunityViewModel()
    @State private var showingNewPostView = false
    @State private var selectedCategory: CommunityPost.Category? = nil
    
    let primaryColor = Color(hex: "#0D3B66")
    let accentColor = Color(hex: "#F95738")
    let backgroundColor = Color(hex: "#F5F9FF")
    let cardColor = Color(hex: "#FFFFFF")
    let textPrimary = Color(hex: "#1A1A1A")
    let textSecondary = Color(hex: "#555555")

    var body: some View {
        NavigationView {
            Group {
                if shouldShowLoading {
                    ProgressView("Loading community posts...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if shouldShowEmpty {
                    emptyStateView
                } else {
                    postListView
                }
            }
            .navigationTitle("Community")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    categoryFilterMenu
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewPostView = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus")
                            Text("Create")
                        }
                        .font(.subheadline)
                        .bold()
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewPostView) {
            NewPostView(viewModel: viewModel)
        }
        .alert("Error", isPresented: $viewModel.showError, presenting: viewModel.errorMessage) { _ in
            Button("OK", role: .cancel) { }
        } message: { message in
            Text(message)
        }
        .onAppear {
            if viewModel.posts.isEmpty {
                viewModel.fetchPosts()
            }
        }
    }

    // MARK: - Computed Views & Helpers

    private var shouldShowLoading: Bool {
        viewModel.isLoading && viewModel.posts.isEmpty
    }

    private var shouldShowEmpty: Bool {
        !viewModel.isLoading && viewModel.posts.isEmpty
    }

    private var postListView: some View {
        List {
            ForEach(filteredPosts) { post in
                PostCardView(viewModel: viewModel, post: post)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .padding(.vertical, 8)
            }
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.fetchPosts()
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)
                .padding(.top, 80)

            Text("No Posts Yet")
                .font(.title2)
                .bold()

            Text("Start a conversation or ask a question to connect with the community.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)

            Button {
                showingNewPostView = true
            } label: {
                Text("Create Your First Post")
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .background(AppColors.primary)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var categoryFilterMenu: some View {
        Menu {
            Button {
                selectedCategory = nil
            } label: {
                Label("All Categories", systemImage: selectedCategory == nil ? "checkmark.circle.fill" : "circle")
            }

            ForEach(CommunityPost.Category.allCases, id: \.self) { category in
                Button {
                    selectedCategory = category
                } label: {
                    Label(category.localizedName, systemImage: category.iconName)
                }
            }
        } label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                .labelStyle(.iconOnly)
                .foregroundColor(.accentColor)
        }
    }

    private var filteredPosts: [CommunityPost] {
        if let category = selectedCategory {
            return viewModel.posts.filter { $0.category == category }
        }
        return viewModel.posts
    }
}
