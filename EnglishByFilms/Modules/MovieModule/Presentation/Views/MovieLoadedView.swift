//
//  MovieLoadedView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 15/08/2026.
//

import SwiftUI

struct MovieLoadedView: View {
    let movie: MovieDetails
    let subtitlePreparationState: MovieSubtitlePreparationState
    let openSubtitles: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                MovieHeroView(movie: movie)
                    .visualEffect { content, geometry in
                        let pullDistance = max(geometry.frame(in: .scrollView).minY, 0)
                        let scale = 1 + pullDistance / max(geometry.size.height, 1)

                        return content.scaleEffect(scale, anchor: .bottom)
                    }

                MovieInformationView(movie: movie)
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
            }
        }
        .scrollEdgeEffectHidden(true, for: .top)
        .scrollBounceBehavior(.always, axes: .vertical)
        .background(.backgroundBase)
        .ignoresSafeArea(edges: .top)
        .safeAreaInset(edge: .bottom) {
            MovieSubtitleActionView(
                state: subtitlePreparationState,
                action: openSubtitles
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(.backgroundBase.opacity(0.94))
        }
    }
}

#Preview {
    MovieLoadedView(
        movie: MovieDetails(
            id: 603,
            title: "The Matrix",
            overview: "A hacker discovers that the world he knows is a simulation.",
            releaseYear: 1999,
            runtimeMinutes: 136,
            backdropURL: nil,
            rating: 8.2,
            genres: ["Action", "Science Fiction"]
        ),
        subtitlePreparationState: .idle,
        openSubtitles: { }
    )
    .preferredColorScheme(.dark)
}
