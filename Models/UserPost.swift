//
//  UserPost.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 19/06/2025.
//


import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserPost: Identifiable, Codable, Equatable {
    
    @DocumentID var id: String?
    let authorID: String
    let authorName: String
    let content: String
    let timestamp: Date
    var isAnonymous: Bool
    var isReported: Bool = false
    var reportReason: String?
    var likes: Int = 0
    var likedBy: [String] = [] // User IDs who liked the post
    
    // UK-specific categories
    enum Category: String, Codable {
        case general, legalAdvice, housing, mentalHealth, jobSeeking, education
    }
    var category: Category = .general
    
    // For safety - don't include location
}

// For previews only
extension UserPost {
    static let samplePosts: [UserPost] = [
        UserPost(
            authorID: "user1",
            authorName: "SafeUser123",
            content: "Just arrived in London. Any recommendations for English classes?",
            timestamp: Date().addingTimeInterval(-86400),
            isAnonymous: true,
            category: .education
        ),
        UserPost(
            authorID: "user2",
            authorName: "NewStart",
            content: "Looking for community support groups in Manchester",
            timestamp: Date().addingTimeInterval(-3600),
            isAnonymous: false,
            category: .mentalHealth
        )
    ]
}
