//
//  SearchView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

import SwiftUI

@MainActor
struct SearchView: View {
    let viewModel: SearchViewModel

    var body: some View {
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
