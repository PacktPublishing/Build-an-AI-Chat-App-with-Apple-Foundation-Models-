//
//  MovieTool.swift
//  FoundationChat
//
//  Created by Mohammad Azam on 8/20/26.
//

import Foundation
import FoundationModels

struct MovieTool: Tool {
    
    let httpClient: HTTPClient
    
    let name = "searchMoviesByTitle"
    let description = """
        Fetches information specifically for movies, films, or cinema titles. 
        Do NOT call this tool for general knowledge, geographical, historical, or non-movie queries.
        """
    
    @Generable
    struct Arguments {
        @Guide(description: "The title of the movie.")
        let title: String
    }
    
    nonisolated func call(arguments: Arguments) async throws -> [Movie] {
        
        print("MovieTool")
        let movies = try await httpClient.loadMovies(searchTerm: arguments.title)
        print(movies)
        return movies.map { $0.toMovie() }
    }
    
}
