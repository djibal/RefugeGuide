//
//  CommunityPost.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 29/06/2025.
//

import SwiftUI
import Foundation
import FirebaseFunctions
import FirebaseFirestoreSwift
<<<<<<< HEAD
import FirebaseAuth
=======
import SwiftUI
import FirebaseFunctions
>>>>>>> f344d62e85b95a56d858d009284b283cacfae5cf

struct CommunityPost: Identifiable, Codable, Hashable {
    @DocumentID var id: String?

    let title: String
    let content: String
    let category: Category
    let authorID: String        
    let authorName: String
    let timestamp: Date

    var isAnonymous: Bool = false
    var likes: Int = 0
    var likedBy: [String] = []
    

    enum Category: String, Codable, CaseIterable {
        case general
        case events
        case announcements
        case tips
        case support
        
        var iconName: String {
            switch self {
            case .general: return "bubble.left.and.bubble.right"
            case .events: return "calendar"
            case .announcements: return "megaphone"
            case .tips: return "lightbulb"
            case .support: return "person.2"
            }
        }
        
        var localizedName: String {
            switch self {
            case .general: return NSLocalizedString("General", comment: "")
            case .events: return NSLocalizedString("Events", comment: "")
            case .announcements: return NSLocalizedString("Announcements", comment: "")
            case .tips: return NSLocalizedString("Tips", comment: "")
            case .support: return NSLocalizedString("Support", comment: "")
            }
        }
        
        var color: Color {
            switch self {
            case .general: return .blue
            case .events: return .green
            case .announcements: return .orange
            case .tips: return .yellow
            case .support: return .purple
            }
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    var relativeTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
    
    static let samplePosts: [CommunityPost] = [
        CommunityPost(
            id: "1",
            title: "Free Legal Workshop",
            content: "Join our free workshop on asylum rights this Friday at 3pm.",
            category: .events,
            authorID: "user1", // ADD THIS
            authorName: "Refugee Council",
            timestamp: Date().addingTimeInterval(-3600)
        ),
        CommunityPost(
            id: "1",
            title: "Free Legal Workshop",
            content: "Join our free workshop on asylum rights this Friday at 3pm.",
            category: .events,
            authorID: "user2",
            authorName: "Refugee Council",
            timestamp: Date().addingTimeInterval(-3600)
        ),
        CommunityPost(
            id: "2",
            title: "Urgent Housing Update",
            content: "Please check your inbox. We sent updated info on temporary housing options.",
            category: .announcements,
            authorID: "user3",
            authorName: "Caseworker Team",
            timestamp: Date().addingTimeInterval(-7200)
        ),
        CommunityPost(
            id: "3",
            title: "Mental Health Tip",
            content: "Take 5 minutes to breathe deeply. It really helps during interviews.",
            category: .tips,
            authorID: "user4", 
            authorName: "Community Volunteer",
            timestamp: Date().addingTimeInterval(-10800)
        )
    ]
}
