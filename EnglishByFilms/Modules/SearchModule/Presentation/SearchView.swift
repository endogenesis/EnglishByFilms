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
                LazyVStack(alignment: .leading) {
                    ForEach(movies) { movie in
                        Button {
                            Task {
                                await viewModel.downloadBestEnglishSubtitle(for: movie)
                            }
                        } label: {
                            SearchMovieRow(movie: movie)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
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
