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
            .navigationTitle("Movie")
            .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case let .placeholder(movieID):
            VStack(spacing: 12) {
                Image(systemName: "film")
                    .font(.system(size: 44))
                    .foregroundStyle(.secondary)

                Text("Movie details")
                    .font(.title2.weight(.semibold))

                Text("TMDB ID: \(movieID)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    NavigationStack {
        MovieModuleBuilder.build(movieID: 550)
    }
}
