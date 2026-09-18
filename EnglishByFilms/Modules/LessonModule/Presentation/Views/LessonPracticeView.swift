//
//  LessonPracticeView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 18/09/2026.
//

import Foundation
import SwiftUI

struct LessonPracticeView: View {
    let exercises: [FillTheGapExercise]
    let currentIndex: Int
    let selectedAnswer: String?
    let selectAnswer: (String) -> Void
    let continueAction: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    LessonProgressHeaderView(
                        eyebrow: "PRACTICE",
                        title: "Fill the gap",
                        currentIndex: currentIndex,
                        totalCount: exercises.count
                    )

                    if let exercise {
                        Text(exercise.prompt)
                            .font(.title2)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(24)
                            .background(.backgroundCard, in: .rect(cornerRadius: 24))

                        VStack(spacing: 12) {
                            ForEach(exercise.choices, id: \.self) { choice in
                                LessonChoiceButton(
                                    title: choice,
                                    correctAnswer: exercise.correctAnswer,
                                    selectedAnswer: selectedAnswer,
                                    action: { selectAnswer(choice) }
                                )
                            }
                        }

                        if let selectedAnswer {
                            Text(feedback(for: selectedAnswer, exercise: exercise))
                                .font(.headline)
                                .foregroundStyle(
                                    answersMatch(selectedAnswer, exercise.correctAnswer)
                                        ? Color.green
                                        : .semanticError
                                )
                        }
                    }
                }
                .padding(24)
            }

            PrimaryButton(buttonTitle, action: continueAction)
                .disabled(selectedAnswer == nil)
                .opacity(selectedAnswer == nil ? 0.5 : 1)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(.backgroundBase.opacity(0.94))
        }
    }

    private var exercise: FillTheGapExercise? {
        exercises.indices.contains(currentIndex) ? exercises[currentIndex] : nil
    }

    private var buttonTitle: String {
        currentIndex == exercises.count - 1 ? "See results" : "Next question"
    }

    private func feedback(for answer: String, exercise: FillTheGapExercise) -> String {
        if answersMatch(answer, exercise.correctAnswer) {
            "Correct"
        } else {
            "The answer is \(exercise.correctAnswer)."
        }
    }

    private func answersMatch(_ lhs: String, _ rhs: String) -> Bool {
        lhs.compare(rhs, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
    }
}
