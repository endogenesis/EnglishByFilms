//
//  LessonView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 27/08/2026.
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
                movieTitle: viewModel.movieTitle,
                currentTime: viewModel.activeCue?.startTime
            )

            LessonFocusStageView(
                cues: viewModel.cues,
                activeIndex: viewModel.activeIndex
            )
            .frame(maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .trailing) {
            LessonProgressRailView(progress: viewModel.progress)
                .padding(.trailing, 10)
        }
        .background(.backgroundBase)
        .task {
            await viewModel.autoAdvance()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .tint(.white)
    }
}

#Preview {
    NavigationStack {
        LessonModuleBuilder.build(
            movieTitle: "The Matrix",
            cues: PreviewSubtitleScript.theMatrix
        )
    }
    .preferredColorScheme(.dark)
}
