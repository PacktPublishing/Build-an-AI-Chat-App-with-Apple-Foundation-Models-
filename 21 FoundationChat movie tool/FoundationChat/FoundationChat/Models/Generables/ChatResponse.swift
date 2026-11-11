//
//  ChatResponse.swift
//  FoundationChat
//
//  Created by Mohammad Azam on 8/20/26.
//

import Foundation
import FoundationModels

@Generable
struct ChatResponse {
    
    @Guide(description: "The assistant's response to the user.")
    let text: String?
    
    @Guide(description: "Movie results when the user asks about movies. Otherwise nil.")
    let movies: [Movie]?
}
