//
//  HelpChatViewModel.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 14/07/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions

class HelpChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isLoading = false
    @Published var errorMessage = ""

    private let functions = Functions.functions()

    func addMessage(_ message: ChatMessage) {
        messages.append(message)
    }

    func addWelcomeMessage() {
        let welcomeMessage = """
        Welcome to RefugeGuide! I'm here to help with information about:

        • UK asylum process
        • Finding housing support
        • Legal advice services
        • Healthcare access
        • Education opportunities
        • Employment support
        • And many more...

        How can I assist you today?
        """
        messages.append(ChatMessage(content: welcomeMessage, isUser: false))
    }

    func sendMessage(_ prompt: String) {
        // quick “escalate to human” path
        if prompt.lowercased().contains("talk to human") || prompt.lowercased().contains("urgent") {
            messages.append(ChatMessage(content: "Connecting you to a human advisor. Please wait…", isUser: false))
            return
        }

        isLoading = true

        let ukContextPrompt = """
        [UK Refugee Context]
        The user is a refugee in the United Kingdom seeking assistance.
        Provide information relevant to UK services, laws, and support systems.
        Be empathetic and practical in your responses.

        User Question: \(prompt)
        """

        let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
        let systemPrompt = "You are an expert refugee advisor responding in \(languageCode). Be clear, kind, and accurate."

        // single callable, no nested duplicate
        functions.httpsCallable("chatWithGPT").call([
            "message": ukContextPrompt,
            "systemPrompt": systemPrompt
        ]) { [weak self] result, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.messages.append(ChatMessage(
                        content: "Sorry, I'm having trouble. Please try again later.",
                        isUser: false
                    ))
                    return
                }

                if let data = result?.data as? [String: Any],
                   let reply = data["reply"] as? String {
                    self.messages.append(ChatMessage(content: reply, isUser: false))
                } else {
                    self.messages.append(ChatMessage(
                        content: "I couldn't process your request. Please try rephrasing.",
                        isUser: false
                    ))
                }
            }
        }
    }
}
