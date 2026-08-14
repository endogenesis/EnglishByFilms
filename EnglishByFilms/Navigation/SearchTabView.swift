//
//  SearchTabView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 14/08/2026.
//

import SwiftUI

struct SearchTabView: View {
    @Bindable private var router: SearchRouter
    private let container: AppContainer

    init(router: SearchRouter, container: AppContainer) {
        self.router = router
        self.container = container
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            container.makeSearchModule(router: router)
                .navigationDestination(for: SearchRoute.self) { route in
                    switch route {
                    case let .movie(id):
                        container.makeMovieModule(movieID: id)
                    }
                }
        }
    }
}

#Preview {
    SearchTabView(
        router: SearchRouter(),
        container: AppContainer(
            movieCatalogService: PreviewMovieCatalogService(),
            subtitleService: PreviewSubtitleService()
        )
    )
}
