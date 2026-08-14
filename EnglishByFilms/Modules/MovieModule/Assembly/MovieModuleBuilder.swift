//
//  MovieModuleBuilder.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 14/08/2026.
//

enum MovieModuleBuilder {
    @MainActor
    static func build(movieID: Int) -> MovieView {
        let viewModel = MovieViewModel(movieID: movieID)

        return MovieView(viewModel: viewModel)
    }
}
