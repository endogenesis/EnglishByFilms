//
//  SearchModuleBuilder.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

enum SearchModuleBuilder {
    @MainActor
    static func build() -> SearchView {
        let router = SearchRouter()
        let viewModel = SearchViewModel(router: router)

        return SearchView(
            router: router,
            viewModel: viewModel
        )
    }
}
