//
//  LessonModuleBuilder.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 19/09/2026.
//

enum LessonModuleBuilder {
    static func build(
        movieTitle: String,
        lessonModel: LessonContent,
        router: LessonRouter
    ) -> LessonView {
        let viewModel = LessonViewModel(
            movieTitle: movieTitle,
            lesson: lessonModel,
            router: router
        )

        return LessonView(viewModel: viewModel)
    }
}
