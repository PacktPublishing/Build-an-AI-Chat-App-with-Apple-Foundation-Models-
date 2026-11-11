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
        
        let locationManager = LocationManager()
        let placeTool = PlaceTool(locationManager: locationManager)
        
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
        },
        makePlaceSession: {
            LanguageModelSession(
                tools: [placeTool]
            ) {
                                    """
                                    You help users find points of interest.
                                                             
                                    Use the place tool to search for real-world
                                    points of interest such as restaurants,
                                    cafes, parks, museums, landmarks, stores,
                                    gyms, hotels, and other physical places.
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
