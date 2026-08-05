//
//  SearchModuleRootView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

import SwiftUI

@MainActor
struct SearchModuleRootView: View {
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
            SearchView(viewModel: viewModel)
        }
    }
}
