//
//  HTTPClient.swift
//  FoundationChat
//
//  Created by Mohammad Azam on 8/20/26.
//

import Foundation

struct HTTPClient {
    
    func loadMovies(searchTerm: String) async throws -> [MovieDTO] {
        
        let (data, _) = try await URLSession.shared.data(from: Constants.Urls.movies(searchTerm: searchTerm))
        let movieResponse = try JSONDecoder().decode(MovieSearchResponse.self, from: data)
        return movieResponse.search
        
    }
    
}
