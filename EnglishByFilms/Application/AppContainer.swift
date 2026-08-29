//
//  AppContainer.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

import SwiftUI

@MainActor
final class AppContainer {
    private let movieCatalogService: MovieCatalogService
    private let subtitleService: SubtitleService

    init() {
        movieCatalogService = TMDBMovieCatalogService(
            configuration: .live()
        )
        subtitleService = OpenSubtitlesService(
            configuration: .live()
        )
    }

    init(
        movieCatalogService: MovieCatalogService,
        subtitleService: SubtitleService
    ) {
        self.movieCatalogService = movieCatalogService
        self.subtitleService = subtitleService
    }

    func makeSearchModule(router: SearchRouter) -> some View {
        SearchModuleBuilder.build(
            router: router,
            movieCatalogService: movieCatalogService
        )
    }

    func makeMovieModule(movieID: Int) -> some View {
        MovieModuleBuilder.build(
            movieID: movieID,
            movieCatalogService: movieCatalogService,
            subtitleService: subtitleService
        )
    }
}
