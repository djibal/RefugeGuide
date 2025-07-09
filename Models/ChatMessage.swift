//
//  ChatMessage.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 15/06/2025.
//

import Foundation

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp = Date()
    
    // For UK context - add message types if needed
    enum MessageType {
        case standard, resourceLink, urgentHelp
    }
    var type: MessageType = .standard
}
