//
//  SearchRouter.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

import Observation

@Observable
final class SearchRouter {
    var path: [SearchRoute] = []
    var presentedLesson: LessonPresentation?

    func showMovie(id: Int) {
        path.append(.movie(id: id))
    }

    func showLesson(_ lesson: LessonContent, movieTitle: String) {
        presentedLesson = LessonPresentation(movieTitle: movieTitle, lesson: lesson)
    }

    func showSubtitles(movieTitle: String, subtitles: SubtitleDocument) {
        path.append(
            .subtitles(
                SubtitleRoute(movieTitle: movieTitle, subtitles: subtitles)
            )
        )
    }

    func dismissLesson() {
        presentedLesson = nil
    }
}
