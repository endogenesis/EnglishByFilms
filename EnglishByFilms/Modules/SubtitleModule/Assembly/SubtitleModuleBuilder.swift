//
//  SubtitleModuleBuilder.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 29/08/2026.
//

enum SubtitleModuleBuilder {
    static func build(
        movieTitle: String,
        subtitles: SubtitleDocument,
        router: SubtitleRouter
    ) -> SubtitleView {
        let viewModel = SubtitleViewModel(
            movieTitle: movieTitle,
            subtitles: subtitles,
            router: router
        )

        return SubtitleView(viewModel: viewModel)
    }
}
