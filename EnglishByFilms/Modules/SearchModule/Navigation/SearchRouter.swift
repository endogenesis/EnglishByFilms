//
//  SearchRouter.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

import Observation

@MainActor
@Observable
final class SearchRouter {
    var path: [SearchRoute] = []

    func showMovie(id: Int) {
        path.append(.movie(id: id))
    }
}
