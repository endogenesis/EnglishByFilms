//
//  LessonLearningView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 18/09/2026.
//

import SwiftUI

struct LessonLearningView: View {
    let movieTitle: String
    let content: LessonContent
    let currentIndex: Int
    let continueAction: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    LessonProgressHeaderView(
                        eyebrow: "LEARN",
                        title: movieTitle,
                        currentIndex: currentIndex,
                        totalCount: content.exercises.count
                    )

                    if let exercise {
                        VStack(alignment: .leading, spacing: 20) {
                            Text(exercise.correctAnswer)
                                .font(.largeTitle.bold())
                                .foregroundStyle(.accent)

                            Text(exercise.sourceText)
                                .font(.title2)
                                .fixedSize(horizontal: false, vertical: true)

                            if let contextTranslation = exercise.contextTranslation {
                                Text(contextTranslation)
                                    .font(.body)
                                    .foregroundStyle(.textSecondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(24)
                        .background(.backgroundCard, in: .rect(cornerRadius: 24))
                    }
                }
                .padding(24)
            }

            PrimaryButton(buttonTitle, action: continueAction)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(.backgroundBase.opacity(0.94))
        }
    }

    private var exercise: FillTheGapExercise? {
        guard content.exercises.indices.contains(currentIndex),
              case let .fillTheGap(exercise) = content.exercises[currentIndex] else {
            return nil
        }

        return exercise
    }

    private var buttonTitle: String {
        currentIndex == content.exercises.count - 1 ? "Continue" : "Next word"
    }
}
