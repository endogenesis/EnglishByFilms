//
//  LessonRouter.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 18/09/2026.
//

final class LessonRouter {
    private let searchRouter: SearchRouter

    init(searchRouter: SearchRouter) {
        self.searchRouter = searchRouter
    }

    func finishLesson() {
        searchRouter.finishLesson()
    }
}
