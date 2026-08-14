//
//  PreviewMovieCatalogService.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 08/08/2026.
//

import Foundation

struct PreviewMovieCatalogService: MovieCatalogService {
    private let movieDetailsCollection = [
        MovieDetails(
            id: 603,
            title: "The Matrix",
            overview: "A hacker discovers that the world he knows is a simulation.",
            releaseYear: 1999,
            runtimeMinutes: 136,
            backdropURL: nil,
            rating: 8.2,
            genres: ["Action", "Science Fiction"]
        ),
        MovieDetails(
            id: 27205,
            title: "Inception",
            overview: "A thief enters people's dreams to steal their secrets.",
            releaseYear: 2010,
            runtimeMinutes: 148,
            backdropURL: nil,
            rating: 8.4,
            genres: ["Action", "Science Fiction", "Adventure"]
        )
    ]

    private var movies: [MovieSummary] {
        movieDetailsCollection.map { details in
            MovieSummary(
                id: details.id,
                title: details.title,
                originalTitle: details.title,
                overview: details.overview,
                releaseYear: details.releaseYear,
                posterURL: nil,
                rating: details.rating,
                genres: details.genres
            )
        }
    }

    func popularMovies(page: Int) async throws -> MoviePage {
        MoviePage(
            movies: movies,
            currentPage: page,
            totalPages: 1
        )
    }

    func searchMovies(query: String, page: Int) async throws -> MoviePage {
        let results = movies.filter {
            $0.title.localizedStandardContains(query)
                || $0.originalTitle.localizedStandardContains(query)
        }

        return MoviePage(
            movies: results,
            currentPage: page,
            totalPages: 1
        )
    }

    func movieDetails(id: Int) async throws -> MovieDetails {
        guard let details = movieDetailsCollection.first(where: { $0.id == id }) else {
            throw MovieCatalogError.invalidData
        }

        return details
    }
}
