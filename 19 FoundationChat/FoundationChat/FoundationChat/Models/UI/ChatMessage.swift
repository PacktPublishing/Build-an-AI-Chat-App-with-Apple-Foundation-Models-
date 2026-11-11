//
//  ChatMessage.swift
//  FoundationChat
//
//  Created by Mohammad Azam on 8/20/26.
//

import Foundation

struct ChatMessage: Identifiable {
    
    enum Role {
        case user
        case assistant
    }
    
    let id: UUID
    let role: Role
    var text: String
    var movies: [Movie.PartiallyGenerated]?
    var places: [Place.PartiallyGenerated]?
    
}
