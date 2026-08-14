//
//  RootTabView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

import SwiftUI

@MainActor
struct RootTabView: View {
    @Bindable private var coordinator: AppCoordinator

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            Tab("Search", systemImage: "magnifyingglass", value: AppTab.search) {
                coordinator.makeSearchTab()
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    RootTabView(
        coordinator: AppCoordinator(
            container: AppContainer(
                movieCatalogService: PreviewMovieCatalogService(),
                subtitleService: PreviewSubtitleService()
            )
        )
    )
}
