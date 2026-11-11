//
//  Constants.swift
//  FoundationChat
//
//  Created by Mohammad Azam on 8/20/26.
//

import Foundation

struct Constants {
    
    struct Urls {
        static func movies(searchTerm: String) -> URL {
            URL(string: "https://omdbapi.com/?s=\(searchTerm)&apikey=564727fa")!
        }
    }
    
}
