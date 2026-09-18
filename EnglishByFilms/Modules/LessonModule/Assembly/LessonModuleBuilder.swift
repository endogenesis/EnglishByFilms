//
//  LessonModuleBuilder.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 18/09/2026.
//

enum LessonModuleBuilder {
    static func build(
        movieTitle: String,
        subtitles: SubtitleDocument,
        router: LessonRouter,
        lessonGenerationService: LessonGenerationService
    ) -> LessonView {
        let viewModel = LessonViewModel(
            movieTitle: movieTitle,
            subtitles: subtitles,
            router: router,
            lessonGenerationService: lessonGenerationService
        )

        return LessonView(viewModel: viewModel)
    }
}
