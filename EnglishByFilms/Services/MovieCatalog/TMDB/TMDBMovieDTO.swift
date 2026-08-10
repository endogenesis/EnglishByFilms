//
//  TMDBMovieDTO.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 08/08/2026.
//

import Foundation

nonisolated struct TMDBMoviePageDTO: Decodable {
    let page: Int
    let results: [TMDBMovieDTO]
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
    }

    func toDomain(imageBaseURL: URL, genreNamesByID: [Int: String]) -> MoviePage {
        MoviePage(
            movies: results.map {
                $0.toDomain(
                    imageBaseURL: imageBaseURL,
                    genreNamesByID: genreNamesByID
                )
            },
            currentPage: page,
            totalPages: totalPages
        )
    }
}

nonisolated struct TMDBMovieDTO: Decodable {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let releaseDate: String?
    let posterPath: String?
    let voteAverage: Double
    let genreIDs: [Int]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case genreIDs = "genre_ids"
    }

    func toDomain(imageBaseURL: URL, genreNamesByID: [Int: String]) -> MovieSummary {
        MovieSummary(
            id: id,
            title: title,
            originalTitle: originalTitle,
            overview: overview,
            releaseYear: releaseYear,
            posterURL: posterURL(imageBaseURL: imageBaseURL),
            rating: voteAverage,
            genres: genreIDs.compactMap { genreNamesByID[$0] }
        )
    }

    private var releaseYear: Int? {
        guard let releaseDate else {
            return nil
        }

        return Int(releaseDate.prefix(4))
    }

    private func posterURL(imageBaseURL: URL) -> URL? {
        guard let posterPath else {
            return nil
        }

        let slashCharacterSet = CharacterSet(charactersIn: "/")
        let normalizedPosterPath = posterPath.trimmingCharacters(in: slashCharacterSet)
        return imageBaseURL.appending(path: normalizedPosterPath)
    }
}
