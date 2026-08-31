//
//  OnboardingPosterCollageView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 31/08/2026.
//

import SwiftUI

struct OnboardingPosterCollageView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ForEach(OnboardingPoster.topRow) { poster in
                    OnboardingPosterCard(poster: poster)
                }
            }
            .offset(x: -22)

            HStack(spacing: 12) {
                ForEach(OnboardingPoster.bottomRow) { poster in
                    OnboardingPosterCard(poster: poster)
                }
            }
            .offset(x: 32)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.3),
                    .init(color: .backgroundBase, location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .allowsHitTesting(false)
        )
        .accessibilityHidden(true)
    }
}

#Preview {
    OnboardingPosterCollageView()
        .frame(maxHeight: .infinity)
        .background(.backgroundBase)
}
