//
//  TMDBMovieDetailsDTO.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 14/08/2026.
//

import Foundation

nonisolated struct TMDBMovieDetailsDTO: Decodable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String?
    let runtime: Int?
    let backdropPath: String?
    let voteAverage: Double
    let genres: [TMDBGenreDTO]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case runtime
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case genres
    }

    func toDomain(backdropImageBaseURL: URL) -> MovieDetails {
        MovieDetails(
            id: id,
            title: title,
            overview: overview,
            releaseYear: releaseYear,
            runtimeMinutes: runtime,
            backdropURL: backdropURL(imageBaseURL: backdropImageBaseURL),
            rating: voteAverage,
            genres: genres.map(\.name)
        )
    }

    private var releaseYear: Int? {
        guard let releaseDate else {
            return nil
        }

        return Int(releaseDate.prefix(4))
    }

    private func backdropURL(imageBaseURL: URL) -> URL? {
        guard let backdropPath else {
            return nil
        }

        let slashCharacterSet = CharacterSet(charactersIn: "/")
        let normalizedBackdropPath = backdropPath.trimmingCharacters(in: slashCharacterSet)
        return imageBaseURL.appending(path: normalizedBackdropPath)
    }
}
