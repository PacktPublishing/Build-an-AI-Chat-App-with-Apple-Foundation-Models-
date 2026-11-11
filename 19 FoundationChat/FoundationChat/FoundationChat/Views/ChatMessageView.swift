//
//  ChatMessageView.swift
//  FoundationChat
//
//  Created by Mohammad Azam on 8/20/26.
//

import SwiftUI

struct ChatMessageView: View {
    
    let chatMessage: ChatMessage
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(chatMessage.text)
                .padding(12)
                .background(chatMessage.role == .user ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                .cornerRadius(12)
            
            if let movies = chatMessage.movies {
                ForEach(movies) { movie in
                    MovieView(movie: movie)
                }
            }
            
            if let places = chatMessage.places {
                PlacesView(places: places)
            }
        }
    }
}

#Preview {
    ChatMessageView(chatMessage: ChatMessage(id: UUID(), role: .user, text: "Hello"))
    ChatMessageView(chatMessage: ChatMessage(id: UUID(), role: .assistant, text: "I am fine. I am your general assistant."))
}
