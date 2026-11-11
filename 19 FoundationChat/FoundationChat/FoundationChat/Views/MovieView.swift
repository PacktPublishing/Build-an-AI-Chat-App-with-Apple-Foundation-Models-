//
//  MovieView.swift
//  FoundationChat
//
//  Created by Mohammad Azam on 8/15/26.
//

import SwiftUI

struct MovieView: View {
    
    let movie: Movie.PartiallyGenerated
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            if let poster = movie.poster {
                AsyncImage(url: URL(string: poster)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle()
                        .fill(.quaternary)
                }
                .frame(width: 70, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title ?? "")
                    .font(.headline)
                
                Text(movie.year ?? "")
                    .foregroundStyle(.secondary)
                
            }
            
            Spacer()
        }
    }
}

