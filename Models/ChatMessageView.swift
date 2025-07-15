//
//  ChatMessageView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 14/07/2025.
//
import Foundation
import SwiftUI
import FirebaseFunctions


struct ChatMessageView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .top) {
            if message.isUser {
                Spacer()
                TextBubble(text: message.content, isUser: true)
            } else {
                TextBubble(text: message.content, isUser: false)
                Spacer()
            }
        }
        .padding(.horizontal, 8)
    }
}

private struct TextBubble: View {
    let text: String
    let isUser: Bool
    
    var body: some View {
        Text(text)
            .padding()
            .foregroundColor(.primary)
            .background(isUser ? Color.blue.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(12)
            .contextMenu {
                Button {
                    UIPasteboard.general.string = text
                } label: {
                    Label("Copy", systemImage: "doc.on.doc")
                }
            }
    }
}

