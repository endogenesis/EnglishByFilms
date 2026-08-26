//
//  MovieViewModel.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 14/08/2026.
//

import Foundation
import Observation

@Observable
final class MovieViewModel {
    private(set) var state: MovieViewState = .loading
    private(set) var subtitlePreparationState: MovieSubtitlePreparationState = .idle

    private let movieID: Int
    private let router: MovieRouter
    private let movieCatalogService: MovieCatalogService
    private let subtitleService: SubtitleService
    private let subtitleParser: SRTSubtitleParser
    private let minimumSubtitlePreparationDuration: Duration
    private let subtitleSelector = SubtitleSelector()
    private var subtitleDocument: SubtitleDocument?

    init(
        movieID: Int,
        router: MovieRouter,
        movieCatalogService: MovieCatalogService,
        subtitleService: SubtitleService,
        subtitleParser: SRTSubtitleParser,
        minimumSubtitlePreparationDuration: Duration = .seconds(20)
    ) {
        self.movieID = movieID
        self.router = router
        self.movieCatalogService = movieCatalogService
        self.subtitleService = subtitleService
        self.subtitleParser = subtitleParser
        self.minimumSubtitlePreparationDuration = minimumSubtitlePreparationDuration
    }

    func loadMovie() async {
        guard case .loading = state else {
            return
        }

        await fetchMovie()
    }

    func retry() async {
        state = .loading
        await fetchMovie()
    }

    private func fetchMovie() async {
        do {
            let movie = try await movieCatalogService.movieDetails(id: movieID)
            try Task.checkCancellation()
            state = .loaded(movie)
        } catch is CancellationError {
            return
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            state = .failed(message: error.localizedDescription)
        }
    }

    func prepareSubtitles() async {
        guard !Task.isCancelled, case let .loaded(movie) = state else {
            return
        }

        switch subtitlePreparationState {
        case .idle, .failed:
            break
        case .subtitleReady:
            if let subtitleDocument {
                router.showSubtitles(movieTitle: movie.title, subtitles: subtitleDocument)
            }
            return
        case .findingSubtitle, .downloadingSubtitle, .preparingSubtitle:
            return
        }

        subtitlePreparationState = .findingSubtitle
        subtitleDocument = nil
        let displayDeadline = ContinuousClock.now.advanced(by: minimumSubtitlePreparationDuration)

        do {
            let page = try await subtitleService.searchEnglishSubtitles(
                tmdbMovieID: movieID,
                page: 1
            )
            try Task.checkCancellation()

            guard let subtitle = subtitleSelector.selectBest(from: page.subtitles) else {
                try await waitForPreparationDisplay(until: displayDeadline)
                subtitlePreparationState = .failed(
                    message: "No supported English subtitles were found for this movie."
                )
                return
            }

            subtitlePreparationState = .downloadingSubtitle
            let downloadedSubtitle = try await subtitleService.downloadSubtitle(
                fileID: subtitle.fileID
            )
            try Task.checkCancellation()

            subtitlePreparationState = .preparingSubtitle
            let subtitleDocument = try subtitleParser.parse(
                downloadedSubtitle,
                sourceLanguage: Locale.Language(identifier: "en")
            )
            try await waitForPreparationDisplay(until: displayDeadline)

            self.subtitleDocument = subtitleDocument
            subtitlePreparationState = .subtitleReady
            router.showSubtitles(movieTitle: movie.title, subtitles: subtitleDocument)
        } catch is CancellationError {
            subtitlePreparationState = .idle
        } catch let error as URLError where error.code == .cancelled {
            subtitlePreparationState = .idle
        } catch {
            let message = error.localizedDescription

            do {
                try await waitForPreparationDisplay(until: displayDeadline)
                subtitlePreparationState = .failed(message: message)
            } catch {
                subtitlePreparationState = .idle
            }
        }
    }

    private func waitForPreparationDisplay(until deadline: ContinuousClock.Instant) async throws {
        try await ContinuousClock().sleep(until: deadline)
        try Task.checkCancellation()
    }
}
