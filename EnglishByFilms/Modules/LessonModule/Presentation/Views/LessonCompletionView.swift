//
//  LessonCompletionView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 18/09/2026.
//

import SwiftUI

struct LessonCompletionView: View {
    let wordCount: Int
    let correctAnswerCount: Int
    let exerciseCount: Int
    let finishAction: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(.accent)

            VStack(spacing: 8) {
                Text("Lesson complete")
                    .font(.largeTitle.bold())

                Text(summary)
                    .font(.body)
                    .foregroundStyle(.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            PrimaryButton("Done", action: finishAction)
        }
        .padding(24)
    }

    private var summary: String {
        if exerciseCount == 0 {
            let result = "You learned \(wordCount) words. "
            let detail = "This lesson did not have enough choices for a useful practice question."
            return result + detail
        } else {
            let result = "You learned \(wordCount) words and answered "
            return result + "\(correctAnswerCount) of \(exerciseCount) questions correctly."
        }
    }
}
