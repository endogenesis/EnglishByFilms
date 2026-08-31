//
//  RootView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 31/08/2026.
//

import SwiftUI

struct RootView: View {
    private let coordinator: AppCoordinator

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    var body: some View {
        ZStack {
            if coordinator.isOnboardingCompleted {
                RootTabView(coordinator: coordinator)
            } else {
                coordinator.makeOnboardingModule()
                    .transition(
                        .asymmetric(
                            insertion: .identity,
                            removal: .move(edge: .leading).combined(with: .opacity)
                        )
                    )
            }
        }
        .animation(.easeInOut(duration: 0.35), value: coordinator.isOnboardingCompleted)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    RootView(
        coordinator: AppCoordinator(
            container: AppContainer(
                movieCatalogService: PreviewMovieCatalogService(),
                subtitleService: PreviewSubtitleService(),
                userPreferencesStore: PreviewUserPreferencesStore()
            )
        )
    )
}
