//
//  MoviePreparationProgressView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 08/09/2026.
//

import SwiftUI

struct MoviePreparationProgressView: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(.accent.opacity(0.15), lineWidth: 4)

            Circle()
                .fill(.accent)
                .frame(width: 7, height: 7)
                .offset(y: -18)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    .linear(duration: 1.2).repeatForever(autoreverses: false),
                    value: isAnimating
                )
        }
        .frame(width: 40, height: 40)
        .onAppear {
            isAnimating = true
        }
        .onDisappear {
            isAnimating = false
        }
    }
}
