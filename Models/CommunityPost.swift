//
//  CommunityPost.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 29/06/2025.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI
import FirebaseFunctions

struct CommunityPost: Identifiable, Codable, Hashable {
    @DocumentID var id: String?

    let title: String
    let content: String
    let category: Category
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
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }

    static let samplePosts: [CommunityPost] = [
        CommunityPost(
            id: "1",
            title: "Free Legal Workshop",
            content: "Join our free workshop on asylum rights this Friday at 3pm.",
            category: .events,
            authorName: "Refugee Council",
            timestamp: Date().addingTimeInterval(-3600)
        ),
        CommunityPost(
            id: "2",
            title: "Urgent Housing Update",
            content: "Please check your inbox. We sent updated info on temporary housing options.",
            category: .announcements,
            authorName: "Caseworker Team",
            timestamp: Date().addingTimeInterval(-7200)
        ),
        CommunityPost(
            id: "3",
            title: "Mental Health Tip",
            content: "Take 5 minutes to breathe deeply. It really helps during interviews.",
            category: .tips,
            authorName: "Community Volunteer",
            timestamp: Date().addingTimeInterval(-10800)
        )
    ]
}

