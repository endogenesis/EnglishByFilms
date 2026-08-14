//
//  SearchViewModel.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

import Foundation
import Observation

@Observable
final class SearchViewModel {
    private(set) var state: SearchViewState = .idle
    var query = ""
    var searchQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private let router: SearchRouter
    private let movieCatalogService: MovieCatalogService
    private let subtitleService: SubtitleService
    private let subtitleSelector = SubtitleSelector()
    private var paginationContext: PaginationContext?
    private var isDownloadingSubtitle = false

    private struct PaginationContext {
        let query: String
        var currentPage: Int
        var totalPages: Int
    }

    init(
        router: SearchRouter,
        movieCatalogService: MovieCatalogService,
        subtitleService: SubtitleService
    ) {
        self.router = router
        self.movieCatalogService = movieCatalogService
        self.subtitleService = subtitleService
    }

    func showMovie(_ movie: MovieSummary) {
        router.showMovie(id: movie.id)
    }

    func loadMovies() async {
        let requestedQuery = searchQuery
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
        } catch is CancellationError {
            return
        } catch let error as URLError where error.code == .cancelled {
            return
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

    func downloadBestEnglishSubtitle(for movie: MovieSummary) async {
        guard !isDownloadingSubtitle else {
            log("Ignoring tap while another subtitle download is in progress")
            return
        }

        isDownloadingSubtitle = true
        defer { isDownloadingSubtitle = false }

        log("Looking for English subtitles for \(movie.title), TMDB ID \(movie.id)")

        do {
            let page = try await subtitleService.searchEnglishSubtitles(
                tmdbMovieID: movie.id,
                page: 1
            )

            guard let subtitle = subtitleSelector.selectBest(from: page.subtitles) else {
                log("No supported single-file English subtitles found for \(movie.title)")
                return
            }

            log("Selector chose \(subtitle.fileName), fileID \(subtitle.fileID)")
            log(
                "Selection metrics: trusted=\(subtitle.fromTrustedSource), "
                    + "hearingImpaired=\(subtitle.hearingImpaired), "
                    + "newDownloads=\(subtitle.newDownloadCount)"
            )
            _ = try await subtitleService.downloadSubtitle(fileID: subtitle.fileID)
        } catch is CancellationError {
            return
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            log("Subtitle flow failed for \(movie.title): \(error.localizedDescription)")
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

    private func log(_ message: String) {
#if DEBUG
        print("[Search] \(message)")
#endif
    }
}
