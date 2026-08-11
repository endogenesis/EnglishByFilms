//
//  OpenSubtitlesConfiguration.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 11/08/2026.
//

import Foundation

struct OpenSubtitlesConfiguration {
    let baseURL: URL
    let apiKey: String
    let userAgent: String

    static func live(bundle: Bundle = .main) -> OpenSubtitlesConfiguration {
        OpenSubtitlesConfiguration(
            baseURL: URL(string: "https://api.opensubtitles.com/api/v1")!,
            apiKey: Secrets.value(for: .openSubtitlesAPIKey, in: bundle),
            userAgent: userAgent(in: bundle)
        )
    }

    // MARK: - Private

    private static func userAgent(in bundle: Bundle) -> String {
        let appName = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String
        let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        return "\(appName ?? "EnglishByFilms") v\(version ?? "1.0")"
    }
}
