//
//  PreviewLessonContent.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 20/09/2026.
//

import Foundation

extension LessonContent {
    static let preview = LessonContent(
        sourceLanguage: Locale.Language(identifier: "en"),
        translationLanguage: Locale.Language(identifier: "ru"),
        exercises: [
            .fillTheGap(
                FillTheGapExercise(
                    id: "fill-the-gap-1",
                    subtitleEntryID: 1,
                    prompt: "She ___ before boarding the train.",
                    sourceText: "She hesitated before boarding the train.",
                    correctAnswer: "hesitated",
                    choices: ["hesitated", "whispered", "hurried", "nodded"],
                    contextTranslation: nil,
                    startTime: 848
                )
            ),
            .fillTheGap(
                FillTheGapExercise(
                    id: "fill-the-gap-2",
                    subtitleEntryID: 2,
                    prompt: "We need to ___ before midnight.",
                    sourceText: "We need to leave before midnight.",
                    correctAnswer: "leave",
                    choices: ["leave", "wait", "listen", "return"],
                    contextTranslation: nil,
                    startTime: 912
                )
            )
        ]
    )
}
