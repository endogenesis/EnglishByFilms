//
//  SubtitleModuleBuilder.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 29/08/2026.
//

enum SubtitleModuleBuilder {
    @MainActor
    static func build(movieTitle: String, subtitles: SubtitleDocument) -> SubtitleView {
        let viewModel = SubtitleViewModel(movieTitle: movieTitle, subtitles: subtitles)

        return SubtitleView(viewModel: viewModel)
    }
}
