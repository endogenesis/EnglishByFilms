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

    let searchRouter = SearchRouter()

    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
    }

    func makeSearchTab() -> some View {
        SearchTabView(router: searchRouter, container: container)
    }
}
