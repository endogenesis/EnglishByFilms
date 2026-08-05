//
//  SearchViewModel.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

import Observation

@MainActor
@Observable
final class SearchViewModel {
    private(set) var state: SearchViewState = .idle

    private let router: SearchRouter

    init(router: SearchRouter) {
        self.router = router
    }
}
