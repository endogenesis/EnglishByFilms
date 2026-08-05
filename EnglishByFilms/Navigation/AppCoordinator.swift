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

    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
    }

    func makeSearchModule() -> some View {
        container.makeSearchModule()
    }
}
