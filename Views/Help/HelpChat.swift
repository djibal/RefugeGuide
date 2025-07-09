//
//  HelpChat.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 29/06/2025.
//


import SwiftUI
import FirebaseFunctions

struct HelpChat: View {
    @StateObject private var viewModel = HelpChatViewModel()
    @State private var inputText: String = ""
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            ChatMessageView(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _ in
                    scrollToBottom(proxy: proxy)
                }
                .onAppear {
                    scrollToBottom(proxy: proxy)
                }
            }
            
            Divider()
            
            HStack {
                TextField("Ask about UK support...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(viewModel.isLoading)
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.horizontal, 4)
                } else {
                    Button {
                        sendMessage()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundColor(inputText.isEmpty ? .gray : .accentColor)
                    }
                    .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .padding()
        }
        .navigationTitle("Refugee Support Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Send initial welcome message
            if viewModel.messages.isEmpty {
                viewModel.addWelcomeMessage()
            }
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let lastMessage = viewModel.messages.last else { return }
        withAnimation {
            proxy.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
    
    private func sendMessage() {
        let userMessage = ChatMessage(content: inputText, isUser: true)
        viewModel.addMessage(userMessage)
        let prompt = inputText
        inputText = ""
        
        viewModel.sendMessage(prompt)
    }
}

struct ChatMessageView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                userMessageView
            } else {
                botMessageView
                Spacer()
            }
        }
    }
    
    private var userMessageView: some View {
        Text(message.content)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
            .contextMenu {
                Button {
                    UIPasteboard.general.string = message.content
                } label: {
                    Label("Copy", systemImage: "doc.on.doc")
                }
            }
    }
    
    private var botMessageView: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "info.circle.fill")
                .foregroundColor(.accentColor)
                .font(.title3)
            
            Text(message.content)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
    }
}

class HelpChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private var functions = Functions.functions()
    
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
        
        How can I assist you today?
        """
        messages.append(ChatMessage(content: welcomeMessage, isUser: false))
    }
    
    func sendMessage(_ prompt: String) {
        isLoading = true
        
        // Add UK context to prompt
        let ukContextPrompt = """
        [UK Refugee Context]
        The user is a refugee in the United Kingdom seeking assistance. 
        Provide information relevant to UK services, laws, and support systems.
        Be empathetic and practical in your responses.
        
        User Question: \(prompt)
        """
        
        functions.httpsCallable("chatWithGPT").call([
            "message": ukContextPrompt,
            "systemPrompt": "You are an expert advisor for refugees in the UK."
        ]) { [weak self] result, error in
            guard let self = self else { return }
            self.isLoading = false
            
            if let error = error {
                self.messages.append(ChatMessage(
                    content: "Sorry, I'm having trouble. Please try again later.",
                    isUser: false
                ))
                self.errorMessage = error.localizedDescription
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
