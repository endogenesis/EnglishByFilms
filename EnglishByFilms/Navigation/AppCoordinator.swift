//
//  AppCoordinator.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

import Observation
import SwiftUI

@MainActor
@Observable
final class AppCoordinator {
    var selectedTab: AppTab = .search
    private(set) var isOnboardingCompleted: Bool

    let searchRouter = SearchRouter()

    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
        isOnboardingCompleted = container.userPreferencesStore.isOnboardingCompleted
    }

    func makeOnboardingModule() -> some View {
        container.makeOnboardingModule { [weak self] in
            self?.isOnboardingCompleted = true
        }
    }

    func makeSearchTab() -> some View {
        SearchTabView(router: searchRouter, container: container)
    }
}
