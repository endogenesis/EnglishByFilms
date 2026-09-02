//
//  SubtitleView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 29/08/2026.
//

import SwiftUI

struct SubtitleView: View {
    @State private var viewModel: SubtitleViewModel

    init(viewModel: SubtitleViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            SubtitleHeaderView(
                movieTitle: viewModel.movieTitle,
                currentTime: viewModel.activeEntry?.startTime
            )

            SubtitleFocusStageView(
                entries: viewModel.entries,
                activeIndex: viewModel.state.activeEntryIndex,
                selectEntry: viewModel.selectEntry(at:)
            )
            .frame(maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .trailing) {
            SubtitleProgressRailView(
                progress: viewModel.progress,
                progressStep: viewModel.progressStep,
                updateProgress: viewModel.selectEntry(atProgress:)
            )
            .padding(.trailing, 10)
        }
        .background(.backgroundBase)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .tint(.white)
    }
}

#Preview {
    NavigationStack {
        SubtitleModuleBuilder.build(
            movieTitle: "The Matrix",
            subtitles: PreviewSubtitleDocument.theMatrix
        )
    }
    .preferredColorScheme(.dark)
}
