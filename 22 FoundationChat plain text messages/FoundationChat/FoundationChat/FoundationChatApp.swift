//
//  FoundationChatApp.swift
//  FoundationChat
//
//  Created by Mohammad Azam on 8/20/26.
//

import SwiftUI
import FoundationModels

@main
struct FoundationChatApp: App {
    
    @State private var chatEngine: ChatEngine
    
    init() {
        
        let session = LanguageModelSession {
            """
            You are a helpful general-purpose assistant.
            """
        }
        
        _chatEngine = State(initialValue: ChatEngine(session: session))
        
    }
    
    var body: some Scene {
        WindowGroup {
            ChatScreen()
                .environment(chatEngine)
        }
    }
}
