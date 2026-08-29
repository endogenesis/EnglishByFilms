//
//  MovieView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 14/08/2026.
//

import SwiftUI

struct MovieView: View {
    @State private var viewModel: MovieViewModel

    init(viewModel: MovieViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        content
            .task {
                await viewModel.loadMovie()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .tint(.white)
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Loading movie…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.backgroundBase)
        case let .loaded(movie):
            MovieLoadedView(
                movie: movie,
                lessonPreparationState: viewModel.lessonPreparationState,
                startLearning: startLearning
            )
        case let .failed(message):
            ContentUnavailableView {
                Label("Couldn’t load movie", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Try again", action: retry)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.backgroundBase)
        }
    }

    private func retry() {
        Task {
            await viewModel.retry()
        }
    }

    private func startLearning() {
        Task {
            await viewModel.prepareLesson()
        }
    }
}

#Preview {
    NavigationStack {
        MovieModuleBuilder.build(
            movieID: 603,
            movieCatalogService: PreviewMovieCatalogService(),
            subtitleService: PreviewSubtitleService()
        )
    }
}
