//
//  LessonViewModel.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 18/09/2026.
//

import Foundation
import Observation

@Observable
final class LessonViewModel {
    private(set) var state: LessonViewState = .loading

    let movieTitle: String

    private let subtitles: SubtitleDocument
    private let router: LessonRouter
    private let lessonGenerationService: LessonGenerationService
    private var activeGenerationID: UUID?

    init(
        movieTitle: String,
        subtitles: SubtitleDocument,
        router: LessonRouter,
        lessonGenerationService: LessonGenerationService
    ) {
        self.movieTitle = movieTitle
        self.subtitles = subtitles
        self.router = router
        self.lessonGenerationService = lessonGenerationService
    }

    func loadLesson() async {
        guard case .loading = state, activeGenerationID == nil else {
            return
        }

        await generateLesson()
    }

    func prepareRetry() {
        switch state {
        case .noSuitableContent, .failed:
            state = .loading
        case .loading, .learning, .practicing, .completed:
            return
        }
    }

    func showNextLearningItem() {
        guard case let .learning(content, currentIndex) = state else {
            return
        }

        let nextIndex = currentIndex + 1
        guard nextIndex >= content.exercises.count else {
            state = .learning(content: content, currentIndex: nextIndex)
            return
        }

        let exercises = usableExercises(in: content)
        if exercises.isEmpty {
            state = .completed(
                wordCount: content.exercises.count,
                correctAnswerCount: 0,
                exerciseCount: 0
            )
        } else {
            state = .practicing(
                content: content,
                exercises: exercises,
                currentIndex: 0,
                selectedAnswer: nil,
                correctAnswerCount: 0
            )
        }
    }

    func selectAnswer(_ answer: String) {
        guard case let .practicing(
            content,
            exercises,
            currentIndex,
            selectedAnswer,
            correctAnswerCount
        ) = state,
        selectedAnswer == nil,
        exercises.indices.contains(currentIndex) else {
            return
        }

        let exercise = exercises[currentIndex]
        let updatedCorrectAnswerCount = answersMatch(answer, exercise.correctAnswer)
            ? correctAnswerCount + 1
            : correctAnswerCount

        state = .practicing(
            content: content,
            exercises: exercises,
            currentIndex: currentIndex,
            selectedAnswer: answer,
            correctAnswerCount: updatedCorrectAnswerCount
        )
    }

    func showNextPracticeItem() {
        guard case let .practicing(
            content,
            exercises,
            currentIndex,
            selectedAnswer,
            correctAnswerCount
        ) = state,
        selectedAnswer != nil else {
            return
        }

        let nextIndex = currentIndex + 1
        if exercises.indices.contains(nextIndex) {
            state = .practicing(
                content: content,
                exercises: exercises,
                currentIndex: nextIndex,
                selectedAnswer: nil,
                correctAnswerCount: correctAnswerCount
            )
        } else {
            state = .completed(
                wordCount: content.exercises.count,
                correctAnswerCount: correctAnswerCount,
                exerciseCount: exercises.count
            )
        }
    }

    func finishLesson() {
        guard case .completed = state else {
            return
        }

        router.finishLesson()
    }

    private func generateLesson() async {
        let generationID = UUID()
        activeGenerationID = generationID

        defer {
            if activeGenerationID == generationID {
                activeGenerationID = nil
            }
        }

        do {
            let content = try await lessonGenerationService.generateExercises(
                from: subtitles,
                translationLanguage: Locale.Language(identifier: "en")
            )
            try Task.checkCancellation()

            guard activeGenerationID == generationID else {
                return
            }

            guard !content.exercises.isEmpty else {
                state = .noSuitableContent
                return
            }

            state = .learning(content: content, currentIndex: 0)
        } catch is CancellationError {
            return
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch LessonGenerationError.noSuitableContent {
            guard !Task.isCancelled, activeGenerationID == generationID else {
                return
            }

            state = .noSuitableContent
        } catch {
            guard !Task.isCancelled, activeGenerationID == generationID else {
                return
            }

            state = .failed(message: error.localizedDescription)
        }
    }

    private func usableExercises(in content: LessonContent) -> [FillTheGapExercise] {
        content.exercises.compactMap { lessonExercise in
            guard case let .fillTheGap(exercise) = lessonExercise else {
                return nil
            }

            let uniqueChoices = Set(exercise.choices.map { $0.lowercased() })
            guard uniqueChoices.count > 1,
                  exercise.choices.contains(where: {
                      answersMatch($0, exercise.correctAnswer)
                  }) else {
                return nil
            }

            return exercise
        }
    }

    private func answersMatch(_ lhs: String, _ rhs: String) -> Bool {
        lhs.compare(rhs, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
    }
}
