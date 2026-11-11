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
       
        _chatEngine = State(initialValue: ChatEngine(classifier: IntentClassifier(),
                                                     makeGeneralSession: {
            LanguageModelSession {
                                        """
                                        You are a helpful general-purpose assistant.
                                        """
            }
        }, makeMovieSession: {
            LanguageModelSession(tools: [movieTool]) {
                                        """
                                        You are a helpful movie assistant.
                                        
                                        Use the movie tool when movie information
                                        is needed.
                                        """
            }
        }
                                                    ))
        
    }
    
    var body: some Scene {
        WindowGroup {
            ChatScreen()
                .environment(chatEngine)
        }
    }
}
