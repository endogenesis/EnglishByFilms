//
//  LessonModuleBuilder.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 27/08/2026.
//

enum LessonModuleBuilder {
    @MainActor
    static func build(movieTitle: String, cues: [SubtitleCue]) -> LessonView {
        let viewModel = LessonViewModel(movieTitle: movieTitle, cues: cues)

        return LessonView(viewModel: viewModel)
    }
}
