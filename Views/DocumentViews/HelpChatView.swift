//
//  HelpChatView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 14/06/2025.
//

import SwiftUI
import FirebaseFunctions

struct HelpChatView: View {
    @State private var messages: [ChatMessage] = []
    @State private var inputText: String = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(messages) { message in
                            HStack {
                                if message.isUser {
                                    Spacer()
                                    Text(message.content)
                                        .padding()
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(12)
                                } else {
                                    Text(message.content)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(12)
                                    Spacer()
                                }
                            }
                            .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _ in
                    withAnimation {
                        proxy.scrollTo(messages.last?.id, anchor: .bottom)
                    }
                }
            }
            
            Divider()
            
            HStack {
                TextField("Type your question here...", text: $inputText)
                    .padding()
                    .frame(minHeight: 50)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .lineLimit(2...5)

                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(isLoading)
                
                if isLoading {
                    ProgressView()
                        .padding(.horizontal, 4)
                } else {
                    Button {
                        sendMessage()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                    }
                    .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .padding()
        }
        .navigationTitle("Help Chat")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func sendMessage() {
        let userMessage = ChatMessage(content: inputText, isUser: true)
        messages.append(userMessage)
        let prompt = inputText
        inputText = ""
        isLoading = true
        
        let systemPrompt = "You are an expert advisor for refugees in the UK. Be clear, supportive, and practical."
        
        // Combine into single String
        let combinedPrompt = "\(systemPrompt)\n\nUser Question: \(prompt)"
        
        OpenAIService.sendMessage(prompt: combinedPrompt) { reply in
            DispatchQueue.main.async {
                isLoading = false
                if let reply = reply {
                    messages.append(ChatMessage(content: reply, isUser: false))
                } else {
                    messages.append(ChatMessage(content: "Sorry, something went wrong.", isUser: false))
                }
            }
        }
    }
}
