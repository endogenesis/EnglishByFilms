//
//  SearchView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

import SwiftUI

struct SearchView: View {
    @State private var router: SearchRouter
    @State private var viewModel: SearchViewModel

    init(
        router: SearchRouter,
        viewModel: SearchViewModel
    ) {
        _router = State(initialValue: router)
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .task(id: viewModel.searchQuery) {
                    if !viewModel.searchQuery.isEmpty {
                        do {
                            try await Task.sleep(for: .milliseconds(350))
                        } catch {
                            return
                        }
                    }

                    await viewModel.loadMovies()
                }
                .navigationTitle("Search")
                .navigationBarTitleDisplayMode(.large)
                .searchable(
                    text: $viewModel.query,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search movies"
                )
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            Text("Idle")
        case .loading:
            ProgressView()
        case let .loaded(movies, nextPage):
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(movies) { movie in
                        Button {
                            Task {
                                await viewModel.downloadBestEnglishSubtitle(for: movie)
                            }
                        } label: {
                            VStack(spacing: 0) {
                                SearchMovieRow(movie: movie)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom, 14)
                                Rectangle()
                                    .fill(Color.white.opacity(0.06))
                                    .frame(height: 1)
                                    .padding(.leading, 72)
                                    .padding(.bottom, 15)
                            }

                        }
                        .buttonStyle(.plain)
                        .task {
                            guard movie.id == movies.last?.id,
                                  nextPage == .ready else {
                                return
                            }

                            await viewModel.loadNextPage()
                        }
                    }

                    if nextPage == .loading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .contentMargins(.horizontal, 24, for: .scrollContent)
            .contentMargins(.top, 8, for: .scrollContent)
        case .empty(let query):
            ContentUnavailableView.search(text: query)
        case let .failed(message):
            Text(message)
        }
    }
}

#Preview {
    SearchModuleBuilder.build(
        movieCatalogService: PreviewMovieCatalogService(),
        subtitleService: PreviewSubtitleService()
    )
}
