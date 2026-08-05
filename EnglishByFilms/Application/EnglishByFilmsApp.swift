//
//  EnglishByFilmsApp.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

import SwiftUI

@main
@MainActor
struct EnglishByFilmsApp: App {
    @State private var coordinator = AppCoordinator(
        container: AppContainer()
    )

    var body: some Scene {
        WindowGroup {
            RootTabView(coordinator: coordinator)
        }
    }
}
