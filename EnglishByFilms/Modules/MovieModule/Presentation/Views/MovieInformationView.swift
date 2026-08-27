//
//  MovieInformationView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 15/08/2026.
//

import SwiftUI

struct MovieInformationView: View {
    let movie: MovieDetails

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(movie.title)
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)

            if !metadata.isEmpty {
                Text(metadata)
                    .font(.subheadline)
                    .foregroundStyle(.textSecondary)
            }

            if !movie.overview.isEmpty {
                Text(movie.overview)
                    .font(.body)
                    .foregroundStyle(.textSecondary)
                    .padding(.top, 4)
            }
        }
    }

    private var metadata: String {
        var components: [String] = []

        if let releaseYear = movie.releaseYear {
            components.append(String(releaseYear))
        }

        components.append(contentsOf: movie.genres)

        if let runtimeMinutes = movie.runtimeMinutes {
            let runtime = Duration.seconds(runtimeMinutes * 60)
                .formatted(.units(allowed: [.hours, .minutes], width: .narrow))
            components.append(runtime)
        }

        if movie.rating > 0 {
            let rating = movie.rating.formatted(.number.precision(.fractionLength(1)))
            components.append("★ \(rating)")
        }

        return components.joined(separator: " · ")
    }
}

#Preview {
    MovieInformationView(
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
    .padding(24)
    .background(.backgroundBase)
    .preferredColorScheme(.dark)
}
