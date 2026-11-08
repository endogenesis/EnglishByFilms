//
//  FillTheGapView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 08/11/2026.
//

import SwiftUI

struct FillTheGapView: View {
    let movieTitle: String
    let exercise: FillTheGapExercise
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Which word was in the original line?")
                    .font(AppTypography.screenTitle)
                Text("\(movieTitle) · \(formattedStartTime)")
                    .font(AppTypography.caption)
                    .foregroundStyle(Color(red: 167 / 255, green: 168 / 255, blue: 181 / 255))
            }
            Text(exercise.prompt)
                .font(AppTypography.question)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 19)
                .padding(.vertical, 24)
                .cardStyle(cornerRadius: 19)
            VStack(spacing: 12) {
                ForEach(exercise.choices, id: \.self) { elem in
                    Text(elem)
                        .font(AppTypography.option)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, minHeight: 53)
                        .cardStyle()

                }
            }

        }
        .multilineTextAlignment(.leading)
        .foregroundStyle(Color(red: 246 / 255, green: 245 / 255, blue: 249 / 255))
    }

    private var formattedStartTime: String {
        let seconds = Int(exercise.startTime)
        return String(format: "%02d:%02d:%02d", seconds / 3600, seconds / 60 % 60, seconds % 60)
    }
}

#Preview {
    FillTheGapView(
        movieTitle: "The Last Train",
        exercise: FillTheGapExercise(
            id: "fill-the-gap-1",
            subtitleEntryID: 1,
            prompt: "She ______ before\nboarding the train.",
            sourceText: "She hesitated before boarding the train.",
            correctAnswer: "hesitated",
            choices: ["hesitated", "whispered", "hurried", "nodded"],
            contextTranslation: nil,
            startTime: 14 * 60 + 8
        )
    )
    .padding(24)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .background(Color(red: 11 / 255, green: 11 / 255, blue: 15 / 255))
    .preferredColorScheme(.dark)
}
