//
//  SubtitleRoute.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 29/08/2026.
//

import Foundation

struct SubtitleRoute: Hashable {
    let movieTitle: String
    let subtitles: SubtitleDocument

    private let id: UUID

    init(movieTitle: String, subtitles: SubtitleDocument) {
        self.movieTitle = movieTitle
        self.subtitles = subtitles
        id = UUID()
    }

    static func == (lhs: SubtitleRoute, rhs: SubtitleRoute) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
