//
//  Secrets.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 11/08/2026.
//

import Foundation

enum Secrets {
    enum Key: String {
        case tmdbAccessToken
        case openSubtitlesAPIKey
    }

    static func value(for key: Key, in bundle: Bundle = .main) -> String {
        let fileURL = bundle.url(forResource: "Secrets", withExtension: "json")

        guard
            let fileURL,
            let data = try? Data(contentsOf: fileURL),
            let values = try? JSONDecoder().decode([String: String].self, from: data),
            let value = values[key.rawValue]
        else {
            return ""
        }

        return value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
