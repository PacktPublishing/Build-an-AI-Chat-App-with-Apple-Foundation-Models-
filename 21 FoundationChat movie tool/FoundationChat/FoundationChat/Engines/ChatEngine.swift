//
//  ChatEngine.swift
//  FoundationChat
//
//  Created by Mohammad Azam on 8/20/26.
//

import Foundation
import FoundationModels
import Observation

@Observable
class ChatEngine {
    
    let session: LanguageModelSession
    private(set) var chatMessages: [ChatMessage] = []
    
    init(session: LanguageModelSession) {
        self.session = session
    }
    
    func send(_ prompt: String) async throws {
        
        chatMessages.append(ChatMessage(id: UUID(), role: .user, text: prompt))
        
        let assistantMessageId = UUID()
        
        chatMessages.append(ChatMessage(id: assistantMessageId, role: .assistant, text: ""))
        
        let stream = session.streamResponse(to: prompt, generating: ChatResponse.self)
        
        for try await partialStream in stream {
            
            guard let index = chatMessages.firstIndex(where: {
                $0.id == assistantMessageId
            }) else { continue }
            
            chatMessages[index].text = partialStream.content.text ?? ""
            chatMessages[index].movies = partialStream.content.movies ?? []
        }
    }
    
}
