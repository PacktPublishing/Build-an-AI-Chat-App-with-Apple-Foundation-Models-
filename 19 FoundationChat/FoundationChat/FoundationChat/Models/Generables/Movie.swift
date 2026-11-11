//
//  Movie.swift
//  FoundationChat
//
//  Created by Mohammad Azam on 8/20/26.
//

import Foundation
import FoundationModels

@Generable
struct Movie {
    
    @Guide(description: "The title of the movie.")
    let title: String
    
    @Guide(description: "The release year of the movie.")
    let year: String
    
    @Guide(description: "The IMDb identifier for the movie.")
    let imdbID: String
    
    @Guide(description: "The type of result, such as movie or series.")
    let type: String
    
    @Guide(description: "The URL for the movie poster.")
    let poster: String
}
