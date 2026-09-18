//
//  LessonView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 18/09/2026.
//

import SwiftUI

struct LessonView: View {
    @State private var viewModel: LessonViewModel
    @State private var generationAttempt = 0

    init(viewModel: LessonViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                LessonLoadingView(movieTitle: viewModel.movieTitle)
            case let .learning(content, currentIndex):
                LessonLearningView(
                    movieTitle: viewModel.movieTitle,
                    content: content,
                    currentIndex: currentIndex,
                    continueAction: viewModel.showNextLearningItem
                )
            case let .practicing(
                _,
                exercises,
                currentIndex,
                selectedAnswer,
                _
            ):
                LessonPracticeView(
                    exercises: exercises,
                    currentIndex: currentIndex,
                    selectedAnswer: selectedAnswer,
                    selectAnswer: viewModel.selectAnswer,
                    continueAction: viewModel.showNextPracticeItem
                )
            case let .completed(wordCount, correctAnswerCount, exerciseCount):
                LessonCompletionView(
                    wordCount: wordCount,
                    correctAnswerCount: correctAnswerCount,
                    exerciseCount: exerciseCount,
                    finishAction: viewModel.finishLesson
                )
            case .noSuitableContent:
                LessonUnavailableView(
                    title: "No lesson available",
                    message: "These subtitles do not contain enough suitable English content.",
                    retryAction: retryLesson
                )
            case let .failed(message):
                LessonUnavailableView(
                    title: "Couldn’t create lesson",
                    message: message,
                    retryAction: retryLesson
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.backgroundBase)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .tint(.white)
        .task(id: generationAttempt) {
            await viewModel.loadLesson()
        }
    }

    private func retryLesson() {
        viewModel.prepareRetry()
        generationAttempt += 1
    }
}

#Preview {
    NavigationStack {
        LessonModuleBuilder.build(
            movieTitle: "The Matrix",
            subtitles: PreviewSubtitleDocument.theMatrix,
            router: LessonRouter(searchRouter: SearchRouter()),
            lessonGenerationService: LocalLessonGenerationService()
        )
    }
    .preferredColorScheme(.dark)
}
