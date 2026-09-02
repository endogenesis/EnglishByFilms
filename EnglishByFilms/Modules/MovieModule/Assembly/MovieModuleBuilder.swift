//
//  MovieModuleBuilder.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 14/08/2026.
//

enum MovieModuleBuilder {
    @MainActor
    static func build(
        movieID: Int,
        router: MovieRouter,
        movieCatalogService: MovieCatalogService,
        subtitleService: SubtitleService,
        subtitleParser: SRTSubtitleParser
    ) -> MovieView {
        let viewModel = MovieViewModel(
            movieID: movieID,
            router: router,
            movieCatalogService: movieCatalogService,
            subtitleService: subtitleService,
            subtitleParser: subtitleParser
        )

        return MovieView(viewModel: viewModel)
    }
}
