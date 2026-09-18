//
//  LessonViewState.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 18/09/2026.
//

enum LessonViewState: Equatable {
    case loading
    case learning(content: LessonContent, currentIndex: Int)
    case practicing(
        content: LessonContent,
        exercises: [FillTheGapExercise],
        currentIndex: Int,
        selectedAnswer: String?,
        correctAnswerCount: Int
    )
    case completed(wordCount: Int, correctAnswerCount: Int, exerciseCount: Int)
    case noSuitableContent
    case failed(message: String)
}
