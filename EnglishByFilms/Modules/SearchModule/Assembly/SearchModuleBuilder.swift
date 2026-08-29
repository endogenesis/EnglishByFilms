//
//  SearchModuleBuilder.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

enum SearchModuleBuilder {
    @MainActor
    static func build(
        router: SearchRouter,
        movieCatalogService: MovieCatalogService
    ) -> SearchView {
        let viewModel = SearchViewModel(
            router: router,
            movieCatalogService: movieCatalogService
        )

        return SearchView(viewModel: viewModel)
    }
}
