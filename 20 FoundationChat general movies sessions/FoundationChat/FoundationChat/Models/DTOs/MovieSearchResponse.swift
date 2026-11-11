//
//  MovieSearchResponse.swift
//  FoundationChat
//
//  Created by Mohammad Azam on 8/20/26.
//

import Foundation

struct MovieSearchResponse: Codable {
    let search: [MovieDTO]
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}

struct MovieDTO: Codable {
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

extension MovieDTO {
    
    nonisolated func toMovie() -> Movie {
        Movie(
            title: title,
            year: year,
            imdbID: imdbID,
            type: type,
            poster: poster
        )
    }
}
