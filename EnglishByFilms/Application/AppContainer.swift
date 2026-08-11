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

    func makeSearchModule() -> some View {
        SearchModuleBuilder.build(
            movieCatalogService: movieCatalogService,
            subtitleService: subtitleService
        )
    }
}
