//
//  LessonGenerationError.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 15/08/2026.
//

import Foundation

nonisolated enum LessonGenerationError: LocalizedError {
    case noSuitableContent

    var errorDescription: String? {
        switch self {
        case .noSuitableContent:
            "The subtitles do not contain enough suitable content for a lesson."
        }
    }
}
