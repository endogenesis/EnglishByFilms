//
//  LessonViewModelTests.swift
//  EnglishByFilmsTests
//
//  Created by Mikalai Tsyhankou on 18/09/2026.
//

import Foundation
import Testing
@testable import EnglishByFilms

struct LessonViewModelTests {
    private let searchRouter = SearchRouter()
    private let lessonGenerationService = LessonGenerationServiceMock()
    private let subtitles = SubtitleDocument(
        fileName: "movie.srt",
        sourceLanguage: Locale.Language(identifier: "en"),
        entries: [
            SubtitleEntry(
                id: 1,
                startTime: 1,
                endTime: 2,
                text: "You need to understand the choice."
            )
        ]
    )
    private let viewModel: LessonViewModel

    init() {
        viewModel = LessonViewModel(
            movieTitle: "The Matrix",
            subtitles: subtitles,
            router: LessonRouter(searchRouter: searchRouter),
            lessonGenerationService: lessonGenerationService
        )
    }

    @Test func loadsLearningContent() async {
        let content = lessonContent()
        lessonGenerationService.results = [.success(content)]

        await viewModel.loadLesson()

        #expect(viewModel.state == .learning(content: content, currentIndex: 0))
        #expect(lessonGenerationService.subtitles == [subtitles])
        #expect(lessonGenerationService.translationLanguages == [
            Locale.Language(identifier: "en")
        ])
    }

    @Test func showsNoSuitableContentState() async {
        lessonGenerationService.results = [
            .failure(LessonGenerationError.noSuitableContent)
        ]

        await viewModel.loadLesson()

        #expect(viewModel.state == .noSuitableContent)
    }

    @Test func retriesAfterFailure() async {
        let content = lessonContent()
        let error = URLError(.badServerResponse)
        lessonGenerationService.results = [
            .failure(error),
            .success(content)
        ]
        await viewModel.loadLesson()

        #expect(viewModel.state == .failed(message: error.localizedDescription))

        viewModel.prepareRetry()
        await viewModel.loadLesson()

        #expect(viewModel.state == .learning(content: content, currentIndex: 0))
        #expect(lessonGenerationService.subtitles.count == 2)
    }

    @Test func keepsSingleChoiceExerciseAsLearningContentWithoutStartingPractice() async {
        let content = lessonContent(choices: ["understand"])
        lessonGenerationService.results = [.success(content)]
        await viewModel.loadLesson()

        viewModel.showNextLearningItem()

        #expect(viewModel.state == .completed(
            wordCount: 1,
            correctAnswerCount: 0,
            exerciseCount: 0
        ))
    }

    @Test func recordsAnswerFeedbackAndCompletesPractice() async {
        let content = lessonContent(choices: ["understand", "remember"])
        lessonGenerationService.results = [.success(content)]
        await viewModel.loadLesson()
        viewModel.showNextLearningItem()

        viewModel.selectAnswer("understand")

        #expect(viewModel.state == .practicing(
            content: content,
            exercises: [fillTheGapExercise(choices: ["understand", "remember"])],
            currentIndex: 0,
            selectedAnswer: "understand",
            correctAnswerCount: 1
        ))

        viewModel.showNextPracticeItem()

        #expect(viewModel.state == .completed(
            wordCount: 1,
            correctAnswerCount: 1,
            exerciseCount: 1
        ))
    }

    @Test func cancelledGenerationDoesNotCommitAnObsoleteResult() async {
        lessonGenerationService.results = [.success(lessonContent())]
        lessonGenerationService.gate.isClosed = true
        let generation = Task { await viewModel.loadLesson() }
        await waitUntil { lessonGenerationService.subtitles.count == 1 }

        generation.cancel()
        lessonGenerationService.gate.open()
        await generation.value

        #expect(viewModel.state == .loading)
    }

    @Test func cancelledGenerationDoesNotCommitAnObsoleteFailure() async {
        lessonGenerationService.results = [.failure(URLError(.badServerResponse))]
        lessonGenerationService.gate.isClosed = true
        let generation = Task { await viewModel.loadLesson() }
        await waitUntil { lessonGenerationService.subtitles.count == 1 }

        generation.cancel()
        lessonGenerationService.gate.open()
        await generation.value

        #expect(viewModel.state == .loading)
    }

    @Test func finishingCompletedLessonReturnsToSubtitles() async {
        searchRouter.showLesson(movieTitle: "The Matrix", subtitles: subtitles)
        lessonGenerationService.results = [
            .success(lessonContent(choices: ["understand"]))
        ]
        await viewModel.loadLesson()
        viewModel.showNextLearningItem()

        viewModel.finishLesson()

        #expect(searchRouter.path.isEmpty)
    }

    private func lessonContent(choices: [String] = ["understand", "remember"]) -> LessonContent {
        LessonContent(
            sourceLanguage: Locale.Language(identifier: "en"),
            translationLanguage: Locale.Language(identifier: "en"),
            exercises: [.fillTheGap(fillTheGapExercise(choices: choices))]
        )
    }

    private func fillTheGapExercise(choices: [String]) -> FillTheGapExercise {
        FillTheGapExercise(
            id: "fill-the-gap-1",
            subtitleEntryID: 1,
            prompt: "You need to ___ the choice.",
            sourceText: "You need to understand the choice.",
            correctAnswer: "understand",
            choices: choices,
            contextTranslation: nil,
            startTime: 1
        )
    }
}
