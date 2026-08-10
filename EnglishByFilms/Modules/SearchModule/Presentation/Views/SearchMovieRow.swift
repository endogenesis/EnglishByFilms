//
//  SearchMovieRow.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 10/08/2026.
//

import SwiftUI

struct SearchMovieRow: View {
    let movie: MovieSummary

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            poster
                .frame(width: 56, height: 84)
                .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)

                if !metadata.isEmpty {
                    Text(metadata)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                if movie.rating > 0 {
                    Text("★ \(movie.rating.formatted(.number.precision(.fractionLength(1))))")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.semanticRating)
                        .modifier(RatingShimmerModifier(isActive: movie.rating >= 8))
                }
            }
        }
    }

    private var metadata: String {
        var components = movie.genres

        if let releaseYear = movie.releaseYear {
            components.insert(String(releaseYear), at: 0)
        }

        return components.joined(separator: " • ")
    }

    @ViewBuilder
    private var poster: some View {
        if let posterURL = movie.posterURL {
            AsyncImage(url: posterURL) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color.secondary.opacity(0.15)
                        ProgressView()
                    }
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    missingPoster
                @unknown default:
                    missingPoster
                }
            }
        } else {
            missingPoster
        }
    }

    private var missingPoster: some View {
        ZStack {
            Color.secondary.opacity(0.15)
            Image(systemName: "photo")
                .foregroundStyle(.secondary)
        }
    }
}

private struct RatingShimmerModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var accessibilityReduceMotion

    let isActive: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        if isActive && !accessibilityReduceMotion {
            content
                .overlay {
                    GeometryReader { geometry in
                        LinearGradient(
                            colors: [
                                .clear,
                                .white.opacity(1),
                                .white,
                                .white.opacity(0.25),
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .phaseAnimator([false, true]) { shine, isAtTrailingEdge in
                            shine.offset(
                                x: isAtTrailingEdge
                                    ? geometry.size.width
                                    : -geometry.size.width
                            )
                        } animation: { isAtTrailingEdge in
                            isAtTrailingEdge
                            ? .easeInOut(duration: 1.5).delay(1.5)
                                : .linear(duration: 0)
                        }
                    }
                    .mask(content)
                    .allowsHitTesting(false)
                }
        } else {
            content
        }
    }
}

#Preview("Search movie row") {
    SearchMovieRow(
        movie: MovieSummary(
            id: 603,
            title: "The Matrix",
            originalTitle: "The Matrix",
            overview: "A hacker discovers that the world he knows is a simulation.",
            releaseYear: 1999,
            posterURL: nil,
            rating: 8.2,
            genres: ["Action", "Science Fiction"]
        )
    )
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(Color.black)
    .preferredColorScheme(.dark)
}
