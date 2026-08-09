//
//  SearchViewModel.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class SearchViewModel {
    private(set) var state: SearchViewState = .idle
    var query = ""

    private let router: SearchRouter
    private let movieCatalogService: MovieCatalogService
    private var paginationContext: PaginationContext?

    private struct PaginationContext {
        let query: String
        var currentPage: Int
        var totalPages: Int
    }

    init(
        router: SearchRouter,
        movieCatalogService: MovieCatalogService
    ) {
        self.router = router
        self.movieCatalogService = movieCatalogService
    }

    func loadMovies() async {
        let requestedQuery = query
        paginationContext = nil
        state = .loading

        do {
            let page = try await loadPage(number: 1, query: requestedQuery)

            guard !page.movies.isEmpty else {
                state = .empty(query: requestedQuery)
                return
            }

            paginationContext = PaginationContext(
                query: requestedQuery,
                currentPage: page.currentPage,
                totalPages: page.totalPages
            )
            state = .loaded(
                movies: page.movies,
                nextPage: nextPageState(for: page)
            )
        } catch {
            paginationContext = nil
            state = .failed(message: error.localizedDescription)
        }
    }

    func loadNextPage() async {
        guard case let .loaded(movies, currentNextPageState) = state,
              var context = paginationContext,
              context.currentPage < context.totalPages else {
            return
        }

        switch currentNextPageState {
        case .ready, .failed:
            break
        case .loading, .finished:
            return
        }

        let nextPageNumber = context.currentPage + 1
        state = .loaded(movies: movies, nextPage: .loading)

        do {
            let page = try await loadPage(number: nextPageNumber, query: context.query)

            context.currentPage = page.currentPage
            context.totalPages = page.totalPages
            paginationContext = context
            state = .loaded(
                movies: appendingUniqueMovies(page.movies, to: movies),
                nextPage: nextPageState(for: page)
            )
        } catch {
            state = .loaded(
                movies: movies,
                nextPage: .failed(message: error.localizedDescription)
            )
        }
    }

    // MARK: - Private

    private func loadPage(number: Int, query: String) async throws -> MoviePage {
        if query.isEmpty {
            try await movieCatalogService.popularMovies(page: number)
        } else {
            try await movieCatalogService.searchMovies(query: query, page: number)
        }
    }

    private func nextPageState(for page: MoviePage) -> SearchNextPageState {
        page.currentPage < page.totalPages ? .ready : .finished
    }

    private func appendingUniqueMovies(
        _ newMovies: [MovieSummary],
        to movies: [MovieSummary]
    ) -> [MovieSummary] {
        var movieIDs = Set(movies.map(\.id))
        let uniqueMovies = newMovies.filter { movieIDs.insert($0.id).inserted }
        return movies + uniqueMovies
    }
}
