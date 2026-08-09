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

    init() {
        movieCatalogService = TMDBMovieCatalogService(
            configuration: .live()
        )
    }

    init(movieCatalogService: MovieCatalogService) {
        self.movieCatalogService = movieCatalogService
    }

    func makeSearchModule() -> some View {
        SearchModuleBuilder.build(
            movieCatalogService: movieCatalogService
        )
    }
}
