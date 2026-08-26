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
            components.append(formattedRuntime(runtimeMinutes))
        }

        if movie.rating > 0 {
            let rating = movie.rating.formatted(.number.precision(.fractionLength(1)))
            components.append("★ \(rating)")
        }

        return components.joined(separator: " · ")
    }

    private func formattedRuntime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60

        switch (hours, remainingMinutes) {
        case (0, let minutes):
            return "\(minutes)m"
        case (let hours, 0):
            return "\(hours)h"
        case let (hours, minutes):
            return "\(hours)h \(minutes)m"
        }
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
