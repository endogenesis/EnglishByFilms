//
//  LessonView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 19/09/2026.
//

import SwiftUI

struct LessonView: View {
    @State private var viewModel: LessonViewModel

    init(viewModel: LessonViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            LessonHeaderView(
                progress: viewModel.progress,
                close: viewModel.close
            )

            LessonExerciseContentView(
                movieTitle: viewModel.movieTitle,
                exercise: viewModel.currentExercise
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.backgroundBase)
        .safeAreaInset(edge: .bottom) {
            PrimaryButton(
                viewModel.primaryActionTitle,
                action: viewModel.performPrimaryAction
            )
            .disabled(!viewModel.isPrimaryActionEnabled)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(.backgroundBase)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        LessonModuleBuilder.build(
            movieTitle: "The Last Train",
            lessonModel: .preview,
            router: LessonRouter(searchRouter: SearchRouter())
        )
    }
    .preferredColorScheme(.dark)
}
