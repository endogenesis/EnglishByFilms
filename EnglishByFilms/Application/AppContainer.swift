//
//  AppContainer.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

import SwiftUI

final class AppContainer {
    private let movieCatalogService: MovieCatalogService
    private let subtitleService: SubtitleService
    private let subtitleParser: SRTSubtitleParser
    private let lessonGenerationService: LessonGenerationService

    init() {
        movieCatalogService = TMDBMovieCatalogService(
            configuration: .live()
        )
        subtitleService = OpenSubtitlesService(
            configuration: .live()
        )
        subtitleParser = SRTSubtitleParser()
        lessonGenerationService = LocalLessonGenerationService()
    }

    init(
        movieCatalogService: MovieCatalogService,
        subtitleService: SubtitleService,
        subtitleParser: SRTSubtitleParser = SRTSubtitleParser(),
        lessonGenerationService: LessonGenerationService = LocalLessonGenerationService()
    ) {
        self.movieCatalogService = movieCatalogService
        self.subtitleService = subtitleService
        self.subtitleParser = subtitleParser
        self.lessonGenerationService = lessonGenerationService
    }

    func makeSearchModule(router: SearchRouter) -> some View {
        SearchModuleBuilder.build(
            router: router,
            movieCatalogService: movieCatalogService
        )
    }

    func makeMovieModule(movieID: Int, searchRouter: SearchRouter) -> some View {
        MovieModuleBuilder.build(
            movieID: movieID,
            router: MovieRouter(searchRouter: searchRouter),
            movieCatalogService: movieCatalogService,
            subtitleService: subtitleService,
            subtitleParser: subtitleParser
        )
    }

    func makeSubtitleModule(
        movieTitle: String,
        subtitles: SubtitleDocument,
        searchRouter: SearchRouter
    ) -> some View {
        SubtitleModuleBuilder.build(
            movieTitle: movieTitle,
            subtitles: subtitles,
            router: SubtitleRouter(searchRouter: searchRouter)
        )
    }

    func makeLessonModule(
        movieTitle: String,
        subtitles: SubtitleDocument,
        searchRouter: SearchRouter
    ) -> some View {
        LessonModuleBuilder.build(
            movieTitle: movieTitle,
            subtitles: subtitles,
            router: LessonRouter(searchRouter: searchRouter),
            lessonGenerationService: lessonGenerationService
        )
    }
}
