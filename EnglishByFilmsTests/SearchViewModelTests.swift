//
//  SearchViewModelTests.swift
//  EnglishByFilmsTests
//
//  Created by Mikalai Tsyhankou on 26/08/2026.
//

import Foundation
import Testing
@testable import EnglishByFilms

struct SearchViewModelTests {
    private let router = SearchRouter()
    private let movieCatalogService = MovieCatalogServiceMock()
    private let viewModel: SearchViewModel

    init() {
        viewModel = SearchViewModel(
            router: router,
            movieCatalogService: movieCatalogService
        )
    }

    // MARK: - Initial load

    @Test func loadsPopularMoviesWhenQueryIsEmpty() async {
        let movies = [MovieSummary.fixture(id: 1), .fixture(id: 2)]
        movieCatalogService.popularMoviesResults = [
            .success(.fixture(movies: movies, currentPage: 1, totalPages: 3))
        ]

        await viewModel.loadMoviesIfNeeded()

        #expect(viewModel.state == .loaded(movies: movies, nextPage: .ready))
        #expect(movieCatalogService.popularMoviesPages == [1])
        #expect(movieCatalogService.searchMoviesCalls.isEmpty)
    }

    @Test func searchesMoviesUsingTrimmedQuery() async {
        let movies = [MovieSummary.fixture(id: 1)]
        movieCatalogService.searchMoviesResults = [.success(.fixture(movies: movies))]
        viewModel.query = "  dune  "

        await viewModel.loadMoviesIfNeeded()

        #expect(viewModel.state == .loaded(movies: movies, nextPage: .finished))
        #expect(movieCatalogService.searchMoviesCalls.count == 1)
        #expect(movieCatalogService.searchMoviesCalls.first?.query == "dune")
        #expect(movieCatalogService.searchMoviesCalls.first?.page == 1)
        #expect(movieCatalogService.popularMoviesPages.isEmpty)
    }

    @Test func showsEmptyStateWhenSearchReturnsNoMovies() async {
        movieCatalogService.searchMoviesResults = [.success(.fixture(movies: []))]
        viewModel.query = "dune"

        await viewModel.loadMoviesIfNeeded()

        #expect(viewModel.state == .empty(query: "dune"))
    }

    @Test func doesNotReloadWhenResultForSameQueryIsAlreadyLoaded() async {
        movieCatalogService.searchMoviesResults = [.success(.fixture())]
        viewModel.query = "dune"

        await viewModel.loadMoviesIfNeeded()
        await viewModel.loadMoviesIfNeeded()

        #expect(movieCatalogService.searchMoviesCalls.count == 1)
    }

    @Test func doesNotReloadWhenEmptyResultForSameQueryIsAlreadyLoaded() async {
        movieCatalogService.searchMoviesResults = [.success(.fixture(movies: []))]
        viewModel.query = "dune"

        await viewModel.loadMoviesIfNeeded()
        await viewModel.loadMoviesIfNeeded()

        #expect(movieCatalogService.searchMoviesCalls.count == 1)
    }

    @Test func reloadsWhenQueryChanges() async {
        movieCatalogService.searchMoviesResults = [
            .success(.fixture(movies: [.fixture(id: 1)])),
            .success(.fixture(movies: [.fixture(id: 2)]))
        ]
        viewModel.query = "dune"
        await viewModel.loadMoviesIfNeeded()

        viewModel.query = "tron"
        await viewModel.loadMoviesIfNeeded()

        #expect(movieCatalogService.searchMoviesCalls.map(\.query) == ["dune", "tron"])
        #expect(viewModel.state == .loaded(movies: [.fixture(id: 2)], nextPage: .finished))
    }

    @Test func setsFailedStateWhenInitialLoadFails() async {
        let error = MovieCatalogError.unauthorized
        movieCatalogService.popularMoviesResults = [.failure(error)]

        await viewModel.loadMoviesIfNeeded()

        #expect(viewModel.state == .failed(message: error.localizedDescription))
    }

    @Test func keepsLoadingStateWhenInitialLoadIsCancelled() async {
        movieCatalogService.popularMoviesResults = [.failure(CancellationError())]

        await viewModel.loadMoviesIfNeeded()

        #expect(viewModel.state == .loading)
    }

    // MARK: - Pagination

    @Test func loadsNextPageAndAppendsUniqueMovies() async {
        movieCatalogService.popularMoviesResults = [
            .success(.fixture(
                movies: [.fixture(id: 1), .fixture(id: 2)],
                currentPage: 1,
                totalPages: 3
            )),
            .success(.fixture(
                movies: [.fixture(id: 2), .fixture(id: 3)],
                currentPage: 2,
                totalPages: 3
            ))
        ]
        await viewModel.loadMoviesIfNeeded()

        await viewModel.loadNextPage()

        #expect(movieCatalogService.popularMoviesPages == [1, 2])
        #expect(viewModel.state == .loaded(
            movies: [.fixture(id: 1), .fixture(id: 2), .fixture(id: 3)],
            nextPage: .ready
        ))
    }

    @Test func marksPaginationFinishedOnLastPage() async {
        movieCatalogService.popularMoviesResults = [
            .success(.fixture(movies: [.fixture(id: 1)], currentPage: 1, totalPages: 2)),
            .success(.fixture(movies: [.fixture(id: 2)], currentPage: 2, totalPages: 2))
        ]
        await viewModel.loadMoviesIfNeeded()

        await viewModel.loadNextPage()

        #expect(viewModel.state == .loaded(
            movies: [.fixture(id: 1), .fixture(id: 2)],
            nextPage: .finished
        ))
    }

    @Test func doesNotLoadNextPageWhenPaginationIsFinished() async {
        movieCatalogService.popularMoviesResults = [
            .success(.fixture(movies: [.fixture(id: 1)], currentPage: 1, totalPages: 1))
        ]
        await viewModel.loadMoviesIfNeeded()

        await viewModel.loadNextPage()

        #expect(movieCatalogService.popularMoviesPages == [1])
    }

    @Test func keepsLoadedMoviesWhenNextPageFails() async {
        let movies = [MovieSummary.fixture(id: 1)]
        let error = MovieCatalogError.server(statusCode: 500)
        movieCatalogService.popularMoviesResults = [
            .success(.fixture(movies: movies, currentPage: 1, totalPages: 3)),
            .failure(error)
        ]
        await viewModel.loadMoviesIfNeeded()

        await viewModel.loadNextPage()

        #expect(viewModel.state == .loaded(
            movies: movies,
            nextPage: .failed(message: error.localizedDescription)
        ))
    }

    @Test func retriesNextPageAfterFailure() async {
        movieCatalogService.popularMoviesResults = [
            .success(.fixture(movies: [.fixture(id: 1)], currentPage: 1, totalPages: 2)),
            .failure(MovieCatalogError.rateLimited),
            .success(.fixture(movies: [.fixture(id: 2)], currentPage: 2, totalPages: 2))
        ]
        await viewModel.loadMoviesIfNeeded()
        await viewModel.loadNextPage()

        await viewModel.loadNextPage()

        #expect(movieCatalogService.popularMoviesPages == [1, 2, 2])
        #expect(viewModel.state == .loaded(
            movies: [.fixture(id: 1), .fixture(id: 2)],
            nextPage: .finished
        ))
    }

    @Test func ignoresLoadNextPageWhileNextPageIsAlreadyLoading() async {
        movieCatalogService.popularMoviesResults = [
            .success(.fixture(movies: [.fixture(id: 1)], currentPage: 1, totalPages: 2)),
            .success(.fixture(movies: [.fixture(id: 2)], currentPage: 2, totalPages: 2))
        ]
        await viewModel.loadMoviesIfNeeded()

        movieCatalogService.gate.isClosed = true
        let firstLoad = Task { await viewModel.loadNextPage() }
        await waitUntil { movieCatalogService.popularMoviesPages == [1, 2] }
        #expect(viewModel.state == .loaded(movies: [.fixture(id: 1)], nextPage: .loading))

        await viewModel.loadNextPage()
        #expect(movieCatalogService.popularMoviesPages == [1, 2])

        movieCatalogService.gate.open()
        await firstLoad.value

        #expect(viewModel.state == .loaded(
            movies: [.fixture(id: 1), .fixture(id: 2)],
            nextPage: .finished
        ))
    }

    // MARK: - Navigation

    @Test func showMoviePushesMovieRoute() {
        viewModel.showMovie(.fixture(id: 42))

        #expect(router.path == [.movie(id: 42)])
    }
}
