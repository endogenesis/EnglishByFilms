//
//  LessonRoute.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 18/09/2026.
//

import Foundation

struct LessonRoute: Hashable {
    let movieTitle: String
    let subtitles: SubtitleDocument

    private let id: UUID

    init(movieTitle: String, subtitles: SubtitleDocument) {
        self.movieTitle = movieTitle
        self.subtitles = subtitles
        id = UUID()
    }

    static func == (lhs: LessonRoute, rhs: LessonRoute) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
