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
    private(set) var lessonPreparationState: MovieLessonPreparationState = .idle

    private let movieID: Int
    private let movieCatalogService: MovieCatalogService
    private let subtitleService: SubtitleService
    private let subtitleSelector = SubtitleSelector()
    private var downloadedSubtitle: DownloadedSubtitle?

    init(
        movieID: Int,
        movieCatalogService: MovieCatalogService,
        subtitleService: SubtitleService
    ) {
        self.movieID = movieID
        self.movieCatalogService = movieCatalogService
        self.subtitleService = subtitleService
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

    func prepareLesson() async {
        switch lessonPreparationState {
        case .idle, .failed:
            break
        case .findingSubtitle, .downloadingSubtitle, .subtitleReady:
            return
        }

        lessonPreparationState = .findingSubtitle
        downloadedSubtitle = nil

        do {
            let page = try await subtitleService.searchEnglishSubtitles(
                tmdbMovieID: movieID,
                page: 1
            )
            try Task.checkCancellation()

            guard let subtitle = subtitleSelector.selectBest(from: page.subtitles) else {
                lessonPreparationState = .failed(
                    message: "No supported English subtitles were found for this movie."
                )
                return
            }

            lessonPreparationState = .downloadingSubtitle
            let downloadedSubtitle = try await subtitleService.downloadSubtitle(
                fileID: subtitle.fileID
            )
            try Task.checkCancellation()
            self.downloadedSubtitle = downloadedSubtitle
            lessonPreparationState = .subtitleReady
        } catch is CancellationError {
            lessonPreparationState = .idle
        } catch let error as URLError where error.code == .cancelled {
            lessonPreparationState = .idle
        } catch {
            lessonPreparationState = .failed(message: error.localizedDescription)
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
