//
//  TMDBConfiguration.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 08/08/2026.
//

import Foundation

struct TMDBConfiguration {
    let baseURL: URL
    let imageBaseURL: URL
    let accessToken: String
    let language: String

    static func live(bundle: Bundle = .main) -> TMDBConfiguration {
        return TMDBConfiguration(
            baseURL: URL(string: "https://api.themoviedb.org/3")!,
            imageBaseURL: URL(string: "https://image.tmdb.org/t/p/w342")!,
            accessToken: Secrets.value(for: .tmdbAccessToken, in: bundle),
            language: "en-US"
        )
    }
}
