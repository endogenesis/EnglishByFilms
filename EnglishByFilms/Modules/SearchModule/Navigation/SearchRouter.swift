//
//  SearchRouter.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

import Observation
import SwiftUI

@MainActor
@Observable
final class SearchRouter {
    var path = NavigationPath()

    func popToRoot() {
        path = NavigationPath()
    }
}
