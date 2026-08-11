//
//  SearchModuleBuilder.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

enum SearchModuleBuilder {
    @MainActor
    static func build(
        movieCatalogService: MovieCatalogService,
        subtitleService: SubtitleService
    ) -> SearchView {
        let router = SearchRouter()
        let viewModel = SearchViewModel(
            router: router,
            movieCatalogService: movieCatalogService,
            subtitleService: subtitleService
        )

        return SearchView(
            router: router,
            viewModel: viewModel
        )
    }
}
