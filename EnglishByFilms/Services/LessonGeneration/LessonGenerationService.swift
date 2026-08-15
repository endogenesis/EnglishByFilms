//
//  LessonGenerationService.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 15/08/2026.
//

import Foundation

nonisolated protocol LessonGenerationService: Sendable {
    func generateExercises(
        from subtitles: SubtitleDocument,
        translationLanguage: Locale.Language
    ) async throws -> LessonContent
}
