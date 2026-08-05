//
//  SearchModuleBuilder.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

import SwiftUI

enum SearchModuleBuilder {
    @MainActor
    static func build() -> some View {
        let router = SearchRouter()
        let viewModel = SearchViewModel(router: router)

        return SearchModuleRootView(
            router: router,
            viewModel: viewModel
        )
    }
}
