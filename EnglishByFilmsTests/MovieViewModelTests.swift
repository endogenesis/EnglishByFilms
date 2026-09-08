//
//  MovieViewModelTests.swift
//  EnglishByFilmsTests
//
//  Created by Mikalai Tsyhankou on 26/08/2026.
//

import Foundation
import Testing
@testable import EnglishByFilms

struct MovieViewModelTests {
    private let searchRouter = SearchRouter()
    private let movieCatalogService = MovieCatalogServiceMock()
    private let subtitleService = SubtitleServiceMock()
    private let subtitleParser = SRTSubtitleParser()
    private let viewModel: MovieViewModel

    init() {
        viewModel = MovieViewModel(
            movieID: 42,
            router: MovieRouter(searchRouter: searchRouter),
            movieCatalogService: movieCatalogService,
            subtitleService: subtitleService,
            subtitleParser: subtitleParser,
            minimumSubtitlePreparationDuration: .zero
        )
    }

    @Test func startsInLoadingState() {
        #expect(viewModel.state == .loading)
    }

    @Test func loadsMovieDetails() async {
        let details = MovieDetails.fixture(id: 42)
        movieCatalogService.movieDetailsResults = [.success(details)]

        await viewModel.loadMovie()

        #expect(viewModel.state == .loaded(details))
        #expect(movieCatalogService.movieDetailsIDs == [42])
    }

    @Test func doesNotReloadWhenMovieIsAlreadyLoaded() async {
        movieCatalogService.movieDetailsResults = [.success(.fixture(id: 42))]
        await viewModel.loadMovie()

        await viewModel.loadMovie()

        #expect(movieCatalogService.movieDetailsIDs == [42])
    }

    @Test func setsFailedStateWhenLoadFails() async {
        let error = MovieCatalogError.server(statusCode: 500)
        movieCatalogService.movieDetailsResults = [.failure(error)]

        await viewModel.loadMovie()

        #expect(viewModel.state == .failed(message: error.localizedDescription))
    }

    @Test func keepsLoadingStateWhenLoadIsCancelled() async {
        movieCatalogService.movieDetailsResults = [.failure(CancellationError())]

        await viewModel.loadMovie()

        #expect(viewModel.state == .loading)
    }

    @Test func retryReloadsAfterFailure() async {
        let details = MovieDetails.fixture(id: 42)
        movieCatalogService.movieDetailsResults = [
            .failure(MovieCatalogError.rateLimited),
            .success(details)
        ]
        await viewModel.loadMovie()

        await viewModel.retry()

        #expect(viewModel.state == .loaded(details))
        #expect(movieCatalogService.movieDetailsIDs == [42, 42])
    }

    // MARK: - Subtitles

    @Test func preparesBestEnglishSubtitleAndNavigates() async throws {
        let movie = MovieDetails.fixture(id: 42, title: "The Matrix")
        let secondBest = SubtitleSummary.fixture(fileID: 1, newDownloadCount: 5)
        let best = SubtitleSummary.fixture(fileID: 2, newDownloadCount: 9)
        movieCatalogService.movieDetailsResults = [.success(movie)]
        subtitleService.searchResults = [.success(.fixture(subtitles: [secondBest, best]))]
        subtitleService.downloadResults = [.success(.fixture())]
        await viewModel.loadMovie()

        await viewModel.prepareSubtitles()

        #expect(subtitleService.searchCalls.count == 1)
        #expect(subtitleService.searchCalls.first?.tmdbMovieID == 42)
        #expect(subtitleService.searchCalls.first?.page == 1)
        #expect(subtitleService.downloadedFileIDs == [2])
        #expect(viewModel.subtitlePreparationState == .subtitleReady)

        let route = try #require(searchRouter.path.first)
        guard case let .subtitles(subtitleRoute) = route else {
            Issue.record("Expected a subtitle route")
            return
        }

        #expect(subtitleRoute.movieTitle == "The Matrix")
        #expect(subtitleRoute.subtitles.entries.map(\.text) == ["Hello"])
    }

    @Test func failsWhenNoSupportedSubtitleIsFound() async {
        movieCatalogService.movieDetailsResults = [.success(.fixture(id: 42))]
        subtitleService.searchResults = [
            .success(.fixture(subtitles: [.fixture(fileID: 1, fileCount: 2)]))
        ]
        await viewModel.loadMovie()

        await viewModel.prepareSubtitles()

        #expect(viewModel.subtitlePreparationState == .failed(
            message: "No supported English subtitles were found for this movie."
        ))
        #expect(subtitleService.downloadedFileIDs.isEmpty)
        #expect(searchRouter.path.isEmpty)
    }

    @Test func keepsMovieStateWhenSubtitlePreparationFails() async {
        let movie = MovieDetails.fixture(id: 42)
        let error = SubtitleServiceError.rateLimited
        movieCatalogService.movieDetailsResults = [.success(movie)]
        subtitleService.searchResults = [.failure(error)]
        await viewModel.loadMovie()

        await viewModel.prepareSubtitles()

        #expect(viewModel.state == .loaded(movie))
        #expect(viewModel.subtitlePreparationState == .failed(
            message: error.localizedDescription
        ))
        #expect(subtitleService.downloadedFileIDs.isEmpty)
        #expect(searchRouter.path.isEmpty)
    }

    @Test func ignoresSubtitleRequestWhilePreparationIsInProgress() async {
        movieCatalogService.movieDetailsResults = [.success(.fixture(id: 42))]
        subtitleService.searchResults = [.success(.fixture(subtitles: [.fixture(fileID: 7)]))]
        subtitleService.downloadResults = [.success(.fixture())]
        await viewModel.loadMovie()

        subtitleService.gate.isClosed = true
        let firstPreparation = Task { await viewModel.prepareSubtitles() }
        await waitUntil { subtitleService.searchCalls.count == 1 }

        await viewModel.prepareSubtitles()
        #expect(subtitleService.searchCalls.count == 1)

        subtitleService.gate.open()
        await firstPreparation.value

        #expect(subtitleService.downloadedFileIDs == [7])
        #expect(viewModel.subtitlePreparationState == .subtitleReady)
    }
}
