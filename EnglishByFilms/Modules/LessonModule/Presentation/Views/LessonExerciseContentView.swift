//
//  LessonExerciseContentView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 20/09/2026.
//

import SwiftUI

struct LessonExerciseContentView: View {
    let movieTitle: String
    let exercise: LessonExercise?

    var body: some View {
        Group {
            if let exercise {
                switch exercise {
                case let .fillTheGap(model):
                    FillTheGapView(movieTitle: movieTitle, exercise: model)
                }
            } else {
                ContentUnavailableView(
                    "No exercise",
                    systemImage: "text.book.closed",
                    description: Text("This lesson does not contain any exercises.")
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(24)
    }

}

#Preview {
    LessonExerciseContentView(
        movieTitle: "The Last Train",
        exercise: LessonContent.preview.exercises.first
    )
        .background(.backgroundBase)
        .preferredColorScheme(.dark)
}
