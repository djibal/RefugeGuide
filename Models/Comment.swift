//
//  Comment.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 16/07/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import FirebaseFirestoreSwift

struct Comment: Identifiable, Codable {
    @DocumentID var id: String?
    let postID: String
    let authorID: String
    let authorName: String
    let content: String
    let timestamp: Date
    var isAnonymous: Bool = false
    

    
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
}
