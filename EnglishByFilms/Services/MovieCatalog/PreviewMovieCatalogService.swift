//
//  PreviewMovieCatalogService.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 08/08/2026.
//

import Foundation

struct PreviewMovieCatalogService: MovieCatalogService {
    private let movies = [
        MovieSummary(
            id: 603,
            title: "The Matrix",
            originalTitle: "The Matrix",
            overview: "A hacker discovers that the world he knows is a simulation.",
            releaseYear: 1999,
            posterURL: nil,
            rating: 8.2,
            genres: ["Action", "Science Fiction"]
        ),
        MovieSummary(
            id: 27205,
            title: "Inception",
            originalTitle: "Inception",
            overview: "A thief enters people's dreams to steal their secrets.",
            releaseYear: 2010,
            posterURL: nil,
            rating: 8.4,
            genres: ["Action", "Science Fiction", "Adventure"]
        )
    ]

    func popularMovies(page: Int) async throws -> MoviePage {
        MoviePage(
            movies: movies,
            currentPage: page,
            totalPages: 1
        )
    }

    func searchMovies(query: String, page: Int) async throws -> MoviePage {
        let normalizedQuery = query.lowercased()
        let results = movies.filter {
            $0.title.lowercased().contains(normalizedQuery)
                || $0.originalTitle.lowercased().contains(normalizedQuery)
        }

        return MoviePage(
            movies: results,
            currentPage: page,
            totalPages: 1
        )
    }
}
