//
//  MovieViewModel.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 14/08/2026.
//

import Observation

@MainActor
@Observable
final class MovieViewModel {
    private(set) var state: MovieViewState

    init(movieID: Int) {
        state = .placeholder(movieID: movieID)
    }
}
