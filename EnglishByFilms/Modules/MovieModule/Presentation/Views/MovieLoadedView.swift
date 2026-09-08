//
//  MovieLoadedView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 15/08/2026.
//

import SwiftUI

struct MovieLoadedView: View {
    @State private var scrollPosition = ScrollPosition(edge: .top)

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

                if subtitlePreparationState.isPreparing {
                    MovieSubtitlePreparationView(state: subtitlePreparationState)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                        .onAppear(perform: revealPreparation)
                }
            }
        }
        .scrollPosition($scrollPosition)
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

    private func revealPreparation() {
        withAnimation(.easeInOut(duration: 0.4)) {
            scrollPosition.scrollTo(edge: .bottom)
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
        subtitlePreparationState: .downloadingSubtitle,
        openSubtitles: { }
    )
    .preferredColorScheme(.dark)
}
