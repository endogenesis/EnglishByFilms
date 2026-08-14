//
//  TMDBConfiguration.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 08/08/2026.
//

import Foundation

struct TMDBConfiguration {
    let baseURL: URL
    let posterImageBaseURL: URL
    let backdropImageBaseURL: URL
    let accessToken: String
    let language: String

    static func live(bundle: Bundle = .main) -> TMDBConfiguration {
        TMDBConfiguration(
            baseURL: URL(string: "https://api.themoviedb.org/3")!,
            posterImageBaseURL: URL(string: "https://image.tmdb.org/t/p/w342")!,
            backdropImageBaseURL: URL(string: "https://image.tmdb.org/t/p/w780")!,
            accessToken: Secrets.value(for: .tmdbAccessToken, in: bundle),
            language: "en-US"
        )
    }
}
