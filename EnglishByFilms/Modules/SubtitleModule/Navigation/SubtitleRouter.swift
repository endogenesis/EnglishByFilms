//
//  SubtitleRouter.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 29/08/2026.
//

final class SubtitleRouter {
    private let searchRouter: SearchRouter

    init(searchRouter: SearchRouter) {
        self.searchRouter = searchRouter
    }

    func showLesson(movieTitle: String, subtitles: SubtitleDocument) {
        searchRouter.showLesson(movieTitle: movieTitle, subtitles: subtitles)
    }
}
