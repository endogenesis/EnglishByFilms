//
//  LessonContent.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 15/08/2026.
//

import Foundation

nonisolated struct LessonContent: Equatable {
    let sourceLanguage: Locale.Language
    let translationLanguage: Locale.Language
    let exercises: [LessonExercise]
}
