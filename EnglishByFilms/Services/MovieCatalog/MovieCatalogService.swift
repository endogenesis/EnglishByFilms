//
//  MovieCatalogService.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 08/08/2026.
//

nonisolated protocol MovieCatalogService: Sendable {
    func popularMovies(page: Int) async throws -> MoviePage

    func searchMovies(query: String, page: Int) async throws -> MoviePage

    func movieDetails(id: Int) async throws -> MovieDetails
}
