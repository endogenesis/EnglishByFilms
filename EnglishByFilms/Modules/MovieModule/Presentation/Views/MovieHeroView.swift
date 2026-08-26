//
//  MovieHeroView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 15/08/2026.
//

import Kingfisher
import SwiftUI

struct MovieHeroView: View {
    let movie: MovieDetails

    var body: some View {
        ZStack {
            MovieHeroPlaceholderView(title: movie.title)

            if let backdropURL = movie.backdropURL {
                KFImage(backdropURL)
                    .placeholder {
                        Color.clear
                    }
                    .fade(duration: 0.25)
                    .resizable()
                    .scaledToFill()
            }

            LinearGradient(
                colors: [.clear, .backgroundBase.opacity(0.15), .backgroundBase],
                startPoint: .center,
                endPoint: .bottom
            )
        }
        .containerRelativeFrame(.horizontal)
        .frame(height: 280)
        .clipped()
        .accessibilityHidden(true)
    }
}

#Preview {
    MovieHeroView(
        movie: MovieDetails(
            id: 603,
            title: "The Matrix",
            overview: "A hacker discovers that the world he knows is a simulation.",
            releaseYear: 1999,
            runtimeMinutes: 136,
            backdropURL: nil,
            rating: 8.2,
            genres: ["Action", "Science Fiction"]
        )
    )
    .preferredColorScheme(.dark)
}
