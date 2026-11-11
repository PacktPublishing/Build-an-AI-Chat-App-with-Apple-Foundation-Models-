//
//  MovieResponse.swift
//  FoundationChat
//
//  Created by Mohammad Azam on 8/25/26.
//

import Foundation
import FoundationModels

@Generable
struct MovieResponse {
    let text: String
    let movies: [Movie]
}
