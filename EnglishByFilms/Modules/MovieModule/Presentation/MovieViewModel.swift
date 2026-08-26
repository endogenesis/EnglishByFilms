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

    private let movieID: Int
    private let movieCatalogService: MovieCatalogService

    init(movieID: Int, movieCatalogService: MovieCatalogService) {
        self.movieID = movieID
        self.movieCatalogService = movieCatalogService
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
}
