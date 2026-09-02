//
//  MovieViewModel.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 14/08/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class MovieViewModel {
    private(set) var state: MovieViewState = .loading
    private(set) var subtitlePreparationState: MovieSubtitlePreparationState = .idle

    private let movieID: Int
    private let router: MovieRouter
    private let movieCatalogService: MovieCatalogService
    private let subtitleService: SubtitleService
    private let subtitleParser: SRTSubtitleParser
    private let subtitleSelector = SubtitleSelector()
    private var subtitleDocument: SubtitleDocument?

    init(
        movieID: Int,
        router: MovieRouter,
        movieCatalogService: MovieCatalogService,
        subtitleService: SubtitleService,
        subtitleParser: SRTSubtitleParser
    ) {
        self.movieID = movieID
        self.router = router
        self.movieCatalogService = movieCatalogService
        self.subtitleService = subtitleService
        self.subtitleParser = subtitleParser
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

    func prepareSubtitles() async {
        guard case let .loaded(movie) = state else {
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
        case .findingSubtitle, .downloadingSubtitle:
            return
        }

        subtitlePreparationState = .findingSubtitle
        subtitleDocument = nil

        do {
            let page = try await subtitleService.searchEnglishSubtitles(
                tmdbMovieID: movieID,
                page: 1
            )
            try Task.checkCancellation()

            guard let subtitle = subtitleSelector.selectBest(from: page.subtitles) else {
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

            let subtitleDocument = try subtitleParser.parse(
                downloadedSubtitle,
                sourceLanguage: Locale.Language(identifier: "en")
            )
            self.subtitleDocument = subtitleDocument
            subtitlePreparationState = .subtitleReady
            router.showSubtitles(movieTitle: movie.title, subtitles: subtitleDocument)
        } catch is CancellationError {
            subtitlePreparationState = .idle
        } catch let error as URLError where error.code == .cancelled {
            subtitlePreparationState = .idle
        } catch {
            subtitlePreparationState = .failed(message: error.localizedDescription)
        }
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
}
