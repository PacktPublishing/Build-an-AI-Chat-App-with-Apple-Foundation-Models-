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
    
    private let classifier: IntentClassifier
    private(set) var chatMessages: [ChatMessage] = []
    
    private let makeGeneralSession: () -> LanguageModelSession
    private let makeMovieSession: () -> LanguageModelSession
    
    private var generalSession: LanguageModelSession
    private var movieSession: LanguageModelSession
    
    init(classifier: IntentClassifier,
         makeGeneralSession: @escaping () -> LanguageModelSession,
         makeMovieSession: @escaping () -> LanguageModelSession) {
        self.classifier = classifier
        self.generalSession = makeGeneralSession()
        self.movieSession = makeMovieSession()
        
        self.makeMovieSession = makeGeneralSession
        self.makeGeneralSession = makeGeneralSession
    }
    
    func send(_ prompt: String) async throws {
        
        chatMessages.append(ChatMessage(id: UUID(), role: .user, text: prompt))
        
        let assistantMessageId = UUID()
        
        chatMessages.append(
            ChatMessage(
                id: assistantMessageId,
                role: .assistant,
                text: ""
            )
        )
        
        let intent = try await classifier.classify(prompt)
        print(intent)
        
        switch intent {
            case .general:
            try await sendGeneral(prompt, assistantMessageId: assistantMessageId)
            case .movies:
            try await sendMovie(prompt, assistantMessageId: assistantMessageId)
        }
    }
    
    private func sendGeneral(_ prompt: String, assistantMessageId: UUID) async throws {
        
        do {
            try await generateGeneralResponse(prompt, assistantMessageId: assistantMessageId)
        } catch LanguageModelSession.GenerationError.exceededContextWindowSize {
            generalSession = makeGeneralSession()
            try await generateGeneralResponse(prompt, assistantMessageId: assistantMessageId)
        }
        
    }
    
    private func sendMovie(
        _ prompt: String,
        assistantMessageId: UUID
    ) async throws {

        do {
            try await generateMovieResponse(
                prompt,
                assistantMessageId: assistantMessageId
            )
        } catch LanguageModelSession.GenerationError.exceededContextWindowSize {

            movieSession = makeMovieSession()

            try await generateMovieResponse(
                prompt,
                assistantMessageId: assistantMessageId
            )
        }
    }
    
    private func generateMovieResponse(
        _ prompt: String,
        assistantMessageId: UUID
    ) async throws {

        let stream = movieSession.streamResponse(
            to: prompt,
            generating: MovieResponse.self
        )

        for try await partialResponse in stream {

            guard let index = chatMessages.firstIndex(
                where: { $0.id == assistantMessageId }
            ) else {
                continue
            }

            chatMessages[index].text =
                partialResponse.content.text ?? ""

            chatMessages[index].movies =
                partialResponse.content.movies
        }
    }
    
    
    private func generateGeneralResponse(_ prompt: String, assistantMessageId: UUID) async throws {
        
        let stream = generalSession.streamResponse(to: prompt, generating: GeneralResponse.self)
        
        for try await partialResponse in stream {

            guard let index = chatMessages.firstIndex(
                where: { $0.id == assistantMessageId }
            ) else {
                continue
            }

            chatMessages[index].text =
                partialResponse.content.text ?? ""
        }
    }
}
