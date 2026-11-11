//
//  ChatScreen.swift
//  FoundationChat
//
//  Created by Mohammad Azam on 8/20/26.
//

import SwiftUI

struct ChatScreen: View {
    
    @Environment(ChatEngine.self) private var chatEngine
    
    @State private var prompt: String = "List top 3 batman movies"
    private let bottomID = "bottom"
    @FocusState private var isPromptFocused: Bool
    
    var body: some View {
        VStack {
            
            ScrollViewReader { proxy in
                
                List {
                    ForEach(chatEngine.chatMessages) { chatMessage in
                        ChatMessageView(chatMessage: chatMessage)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                    
                    Color.clear
                        .frame(height: 1)
                        .id(bottomID)
                        .listRowSeparator(.hidden)
                }.listStyle(.plain)
                    .onChange(of: chatEngine.chatMessages.last?.text) {
                        withAnimation {
                            proxy.scrollTo(bottomID, anchor: .bottom)
                        }
                    }
                
            }
            
            Divider()
            
            HStack(spacing: 12) {
                TextField(
                    "Ask anything...",
                    text: $prompt,
                    axis: .vertical
                )
                .textFieldStyle(.plain)
                .lineLimit(1...5)
                .focused($isPromptFocused)
                
                Button {
                    isPromptFocused = false
                    // Send prompt
                    Task { await sendPrompt() }
                    
                } label: {
                    Image(systemName: "arrow.up")
                        .fontWeight(.semibold)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .disabled(prompt.isEmpty)
            }
            .padding()
            
        }
    }
    
    private func sendPrompt() async {
        
        let question = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !question.isEmpty else { return }
        
        prompt = ""
        
        do {
            try await chatEngine.send(question)
        } catch {
            print(error.localizedDescription)
        }
        
    }
}

