//
//  LessonExercise.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 15/08/2026.
//

nonisolated enum LessonExercise: Identifiable, Equatable {
    case fillTheGap(FillTheGapExercise)

    var id: String {
        switch self {
        case .fillTheGap(let exercise):
            exercise.id
        }
    }
}
