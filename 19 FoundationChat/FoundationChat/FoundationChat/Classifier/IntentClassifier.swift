//
//  IntentClassifier.swift
//  FoundationChat
//
//  Created by Mohammad Azam on 8/25/26.
//

import Foundation
import FoundationModels

struct IntentClassifier {
    
    func classify(_ prompt: String) async throws -> Intent {
        
        let session = LanguageModelSession {
                        """
                        Classify the user's request into exactly one category.

                        general:
                        Anything that is not specifically a movie search or a request
                        to find real-world points of interest.

                        movies:
                        Requests to search for movies, films, or showtimes.

                        places:
                        ONLY requests to find specific real-world points of interest,
                        businesses, or attractions such as restaurants, cafes, parks,
                        museums, landmarks, stores, gyms, or hotels.

                        Examples:
                        "Find 3 burger places in Houston" -> places
                        "Coffee shops near me" -> places
                        "Museums in Chicago" -> places
                        "Find a gym nearby" -> places

                        "What is the population of Houston?" -> general
                        "Where is Houston?" -> general
                        "What is the capital of Texas?" -> general
                        "Tell me about the Eiffel Tower" -> general
                        "How far is Houston from Dallas?" -> general

                        "Find Batman movies" -> movies
                        """
        }
        
        let response = try await session.respond(to: prompt, generating: Intent.self)
        return response.content
    }
    
}
