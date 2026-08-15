//
//  LocalLessonGenerationService.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 15/08/2026.
//

import Foundation
import NaturalLanguage

nonisolated struct LocalLessonGenerationService: LessonGenerationService {
    private let maximumExerciseCount = 4
    private let minimumWordLength = 5
    private let commonWords: Set<String> = [
        "about", "after", "again", "being", "could", "every", "first", "going",
        "have", "just", "other", "really", "should", "something", "their", "there",
        "these", "thing", "think", "those", "through", "where", "which", "would"
    ]

    init() {}

    func generateExercises(
        from subtitles: SubtitleDocument,
        translationLanguage: Locale.Language
    ) async throws -> LessonContent {
        var fillTheGapExercises: [FillTheGapExercise] = []
        var normalizedAnswers = Set<String>()

        for subtitle in subtitles.entries {
            guard let exercise = makeExercise(from: subtitle) else {
                continue
            }

            guard normalizedAnswers.insert(exercise.correctAnswer.lowercased()).inserted else {
                continue
            }

            fillTheGapExercises.append(exercise)

            if fillTheGapExercises.count == maximumExerciseCount {
                break
            }
        }

        guard !fillTheGapExercises.isEmpty else {
            throw LessonGenerationError.noSuitableContent
        }

        let choices = fillTheGapExercises.map(\.correctAnswer)
        let exercises = fillTheGapExercises.map {
            LessonExercise.fillTheGap(addingChoices(choices, to: $0))
        }

        return LessonContent(
            sourceLanguage: subtitles.sourceLanguage,
            translationLanguage: translationLanguage,
            exercises: exercises
        )
    }

    // MARK: - Private

    private func makeExercise(from subtitle: SubtitleEntry) -> FillTheGapExercise? {
        var prompt = subtitle.text

        guard let targetRange = targetRange(in: prompt) else {
            return nil
        }

        let correctAnswer = String(prompt[targetRange])
        prompt.replaceSubrange(targetRange, with: "___")

        return FillTheGapExercise(
            id: "fill-the-gap-\(subtitle.id)",
            subtitleEntryID: subtitle.id,
            prompt: prompt,
            sourceText: subtitle.text,
            correctAnswer: correctAnswer,
            choices: [],
            contextTranslation: nil,
            startTime: subtitle.startTime
        )
    }

    private func addingChoices(
        _ choices: [String],
        to exercise: FillTheGapExercise
    ) -> FillTheGapExercise {
        FillTheGapExercise(
            id: exercise.id,
            subtitleEntryID: exercise.subtitleEntryID,
            prompt: exercise.prompt,
            sourceText: exercise.sourceText,
            correctAnswer: exercise.correctAnswer,
            choices: choices,
            contextTranslation: exercise.contextTranslation,
            startTime: exercise.startTime
        )
    }

    private func targetRange(in text: String) -> Range<String.Index>? {
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.setLanguage(.english)
        tokenizer.string = text

        return tokenizer.tokens(for: text.startIndex..<text.endIndex)
            .filter { isCandidate(String(text[$0])) }
            .max { text[$0].count < text[$1].count }
    }

    private func isCandidate(_ word: String) -> Bool {
        let normalizedWord = word.lowercased()

        return word.count >= minimumWordLength
            && word.allSatisfy { $0.isLetter || $0 == "'" }
            && !commonWords.contains(normalizedWord)
    }
}
