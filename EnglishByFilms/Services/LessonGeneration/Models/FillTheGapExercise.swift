//
//  FillTheGapExercise.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 15/08/2026.
//

import Foundation

nonisolated struct FillTheGapExercise: Identifiable, Equatable {
    let id: String
    let subtitleEntryID: Int
    let prompt: String
    let sourceText: String
    let correctAnswer: String
    let choices: [String]
    let contextTranslation: String?
    let startTime: TimeInterval
}
