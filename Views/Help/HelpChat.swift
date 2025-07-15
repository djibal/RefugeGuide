//
//  HelpChat.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 29/06/2025.
//

import Foundation
import SwiftUI
import FirebaseFunctions

struct HelpChat: View {
    @StateObject private var viewModel = HelpChatViewModel()
    @State private var inputText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
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
            
            HStack(alignment: .bottom, spacing: 8) {
                ZStack(alignment: .leading) {
                    if inputText.isEmpty {
                        Text("Type your message here…")
                            .foregroundColor(.gray)
                            .padding(.leading, 12)
                            .padding(.vertical, 8)
                    }
                    
                    TextEditor(text: $inputText)
                        .frame(minHeight: 40, maxHeight: 120)
                        .padding(8)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                        .opacity(inputText.isEmpty ? 0.85 : 1)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        .disabled(viewModel.isLoading)
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.horizontal, 4)
                } else {
                    Button {
                        sendMessage()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(inputText.isEmpty ? .gray : .accentColor)
                    }
                    .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color(.systemBackground))
        }
        .navigationTitle("Refugee Support Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
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
