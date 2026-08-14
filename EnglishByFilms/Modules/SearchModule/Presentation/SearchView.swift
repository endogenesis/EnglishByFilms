//
//  SearchView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
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
                            viewModel.showMovie(movie)
                        } label: {
                            VStack(spacing: 0) {
                                SearchMovieRow(movie: movie)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom, 14)
                                Rectangle()
                                    .fill(Color.white.opacity(0.06))
                                    .frame(height: 1)
                                    .padding(EdgeInsets(top: 0, leading: 72, bottom: 15, trailing: 0))
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

                    switch nextPage {
                    case .loading:
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    case let .failed(message):
                        SearchPaginationFailureView(message: message) {
                            Task {
                                await viewModel.loadNextPage()
                            }
                        }
                    case .ready, .finished:
                        EmptyView()
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
    SearchTabView(
        router: SearchRouter(),
        container: AppContainer(
            movieCatalogService: PreviewMovieCatalogService(),
            subtitleService: PreviewSubtitleService()
        )
    )
}
