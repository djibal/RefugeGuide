//
//  CommunityView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 29/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions

struct CommunityView: View {
    @StateObject var viewModel = CommunityViewModel()
    @State private var showingNewPostView = false
    @State private var selectedCategory: CommunityPost.Category? = nil
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading community posts...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.posts.isEmpty {
                    emptyStateView
                } else {
                    postListView
                }
            }
            .navigationTitle("Community Support")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingNewPostView = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    categoryFilterMenu
                }
            }
            .sheet(isPresented: $showingNewPostView) {
                NewPostView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchPosts()
            }
            .alert("Error", isPresented: $viewModel.showError, presenting: viewModel.errorMessage) { _ in
                Button("OK", role: .cancel) { }
            } message: { message in
                Text(message)
            }
        }
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
            Image(systemName: "person.3.fill")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)
            
            Text("Welcome to the Community")
                .font(.title2)
                .bold()
            
            Text("Be the first to share your experiences, ask questions, or offer support to fellow refugees in the UK.")
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
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
            }
        }
        .padding(.top, 40)
        .frame(maxHeight: .infinity)
    }
    
    private var categoryFilterMenu: some View {
        Menu {
            Button {
                selectedCategory = nil
            } label: {
                Label("All Categories", systemImage: selectedCategory == nil ? "checkmark" : "")
            }
            
            ForEach(CommunityPost.Category.allCases, id: \.self) { category in
                Button {
                    selectedCategory = category
                } label: {
                    Label(category.rawValue.capitalized,
                          systemImage: selectedCategory == category ? "checkmark" : "")
                }
            }
        } label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                .symbolVariant(selectedCategory == nil ? .none : .fill)
        }
    }
    
    private var filteredPosts: [CommunityPost] {
        if let category = selectedCategory {
            return viewModel.posts.filter { $0.category == category }
        }
        return viewModel.posts
    }
}

#Preview {
    CommunityView(viewModel: CommunityViewModel(posts: CommunityPost.samplePosts))
}
#if DEBUG
struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView(viewModel: CommunityViewModel.mock)
    }
}
#endif
