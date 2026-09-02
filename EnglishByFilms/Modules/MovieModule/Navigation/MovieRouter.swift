//
//  MovieRouter.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 14/08/2026.
//

@MainActor
final class MovieRouter {
    private let searchRouter: SearchRouter

    init(searchRouter: SearchRouter) {
        self.searchRouter = searchRouter
    }

    func showSubtitles(movieTitle: String, subtitles: SubtitleDocument) {
        searchRouter.showSubtitles(movieTitle: movieTitle, subtitles: subtitles)
    }
}
