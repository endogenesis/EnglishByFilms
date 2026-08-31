//
//  AppContainer.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

import SwiftUI

@MainActor
final class AppContainer {
    let userPreferencesStore: UserPreferencesStore

    private let movieCatalogService: MovieCatalogService
    private let subtitleService: SubtitleService
    private let subtitleParser: SRTSubtitleParser

    init() {
        movieCatalogService = TMDBMovieCatalogService(
            configuration: .live()
        )
        subtitleService = OpenSubtitlesService(
            configuration: .live()
        )
        subtitleParser = SRTSubtitleParser()
        userPreferencesStore = UserDefaultsUserPreferencesStore()
    }

    init(
        movieCatalogService: MovieCatalogService,
        subtitleService: SubtitleService,
        subtitleParser: SRTSubtitleParser = SRTSubtitleParser(),
        userPreferencesStore: UserPreferencesStore
    ) {
        self.movieCatalogService = movieCatalogService
        self.subtitleService = subtitleService
        self.subtitleParser = subtitleParser
        self.userPreferencesStore = userPreferencesStore
    }

    func makeOnboardingModule(onFinish: @escaping () -> Void) -> some View {
        OnboardingModuleBuilder.build(
            userPreferencesStore: userPreferencesStore,
            onFinish: onFinish
        )
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

    func makeSubtitleModule(movieTitle: String, subtitles: SubtitleDocument) -> some View {
        SubtitleModuleBuilder.build(movieTitle: movieTitle, subtitles: subtitles)
    }
}
