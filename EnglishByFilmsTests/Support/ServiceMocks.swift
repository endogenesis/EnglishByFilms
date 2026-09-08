//
//  ServiceMocks.swift
//  EnglishByFilmsTests
//
//  Created by Mikalai Tsyhankou on 26/08/2026.
//

import Foundation
@testable import EnglishByFilms

struct UnqueuedCallError: Error {}

/// Suspends mock responses while closed, so a test can observe a view model
/// mid-request and assert reentrancy guards deterministically.
final class MockGate {
    var isClosed = false
    private var continuations: [CheckedContinuation<Void, Never>] = []

    func waitIfClosed() async {
        guard isClosed else {
            return
        }

        await withCheckedContinuation { continuations.append($0) }
    }

    func open() {
        isClosed = false
        let pending = continuations
        continuations = []
        pending.forEach { $0.resume() }
    }
}

@MainActor
final class MovieCatalogServiceMock: MovieCatalogService {
    var popularMoviesResults: [Result<MoviePage, any Error>] = []
    var searchMoviesResults: [Result<MoviePage, any Error>] = []
    var movieDetailsResults: [Result<MovieDetails, any Error>] = []

    private(set) var popularMoviesPages: [Int] = []
    private(set) var searchMoviesCalls: [(query: String, page: Int)] = []
    private(set) var movieDetailsIDs: [Int] = []

    let gate = MockGate()

    @MainActor
    func popularMovies(page: Int) async throws -> MoviePage {
        popularMoviesPages.append(page)
        await gate.waitIfClosed()
        return try takeNext(from: &popularMoviesResults)
    }

    @MainActor
    func searchMovies(query: String, page: Int) async throws -> MoviePage {
        searchMoviesCalls.append((query: query, page: page))
        await gate.waitIfClosed()
        return try takeNext(from: &searchMoviesResults)
    }

    @MainActor
    func movieDetails(id: Int) async throws -> MovieDetails {
        movieDetailsIDs.append(id)
        await gate.waitIfClosed()
        return try takeNext(from: &movieDetailsResults)
    }
}

@MainActor
final class SubtitleServiceMock: SubtitleService {
    var searchResults: [Result<SubtitlePage, any Error>] = []
    var downloadResults: [Result<DownloadedSubtitle, any Error>] = []

    private(set) var searchCalls: [(tmdbMovieID: Int, page: Int)] = []
    private(set) var downloadedFileIDs: [Int] = []

    let gate = MockGate()

    @MainActor
    func searchEnglishSubtitles(tmdbMovieID: Int, page: Int) async throws -> SubtitlePage {
        searchCalls.append((tmdbMovieID: tmdbMovieID, page: page))
        await gate.waitIfClosed()
        return try takeNext(from: &searchResults)
    }

    @MainActor
    func downloadSubtitle(fileID: Int) async throws -> DownloadedSubtitle {
        downloadedFileIDs.append(fileID)
        await gate.waitIfClosed()
        return try takeNext(from: &downloadResults)
    }
}

private func takeNext<Value>(from results: inout [Result<Value, any Error>]) throws -> Value {
    guard !results.isEmpty else {
        throw UnqueuedCallError()
    }

    return try results.removeFirst().get()
}
