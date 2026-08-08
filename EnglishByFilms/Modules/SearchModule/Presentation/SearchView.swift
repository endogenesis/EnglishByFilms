//
//  SearchView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

import SwiftUI

@MainActor
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
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    SearchModuleBuilder.build()
}
