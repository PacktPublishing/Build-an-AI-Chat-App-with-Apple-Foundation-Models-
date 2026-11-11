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
        
        let httpClient = HTTPClient()
        let movieTool = MovieTool(httpClient: httpClient)
        
        let session = LanguageModelSession(tools: [movieTool]) {
            """
            You are a helpful general-purpose assistant.
            
            TOOL USAGE: 
            - Use `searchMoviesByTitle` only when the user asks about movies, films, or TV shows.
            - Answer general knowledge questions directly without using tools.
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
