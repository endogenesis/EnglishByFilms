//
//  LessonViewModel.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 19/09/2026.
//

import Observation

@Observable
final class LessonViewModel {
    private let router: LessonRouter
    let movieTitle: String
    private let lesson: LessonContent
    private(set) var state = LessonViewState()

    init(movieTitle: String, lesson: LessonContent, router: LessonRouter) {
        self.movieTitle = movieTitle
        self.lesson = lesson
        self.router = router
    }

    var progress: Double {
        guard !lesson.exercises.isEmpty else { return 0 }
        return Double(state.currentExerciseIndex + 1) / Double(lesson.exercises.count)
    }

    var currentExercise: LessonExercise? {
        guard lesson.exercises.indices.contains(state.currentExerciseIndex) else {
            return nil
        }

        return lesson.exercises[state.currentExerciseIndex]
    }

    var primaryActionTitle: String {
        guard let lastExerciseIndex = lesson.exercises.indices.last else {
            return "Continue"
        }

        return state.currentExerciseIndex == lastExerciseIndex ? "Finish" : "Continue"
    }

    var isPrimaryActionEnabled: Bool {
        currentExercise != nil
    }

    func close() {
        router.close()
    }

    func performPrimaryAction() {
        let nextIndex = state.currentExerciseIndex + 1

        guard lesson.exercises.indices.contains(nextIndex) else {
            router.close()
            return
        }

        state.currentExerciseIndex = nextIndex
    }
}
