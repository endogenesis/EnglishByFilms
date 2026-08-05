//
//  AppContainer.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

import SwiftUI

@MainActor
final class AppContainer {
    func makeSearchModule() -> some View {
        SearchModuleBuilder.build()
    }
}
