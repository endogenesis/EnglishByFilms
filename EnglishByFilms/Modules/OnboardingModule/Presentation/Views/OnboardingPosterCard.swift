//
//  OnboardingPosterCard.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 31/08/2026.
//

import SwiftUI

struct OnboardingPosterCard: View {
    let poster: OnboardingPoster

    var body: some View {
        ZStack {
            Circle()
                .fill(poster.topGlowColor)
                .frame(width: 130, height: 130)
                .blur(radius: 24)
                .offset(x: 45, y: -47)

            Circle()
                .fill(poster.bottomGlowColor)
                .frame(width: 115, height: 115)
                .blur(radius: 24)
                .offset(x: -35, y: 65)

            Text(poster.title)
                .font(.system(size: 9, weight: .bold))
                .fontWidth(.expanded)
                .foregroundStyle(.white)
                .lineLimit(1)
                .padding(.leading, 10)
                .padding(.bottom, 12)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
        .frame(width: 96, height: 144)
        .background(.backgroundElevated)
        .clipShape(.rect(cornerRadius: 12))
    }
}

#Preview {
    OnboardingPosterCard(poster: OnboardingPoster.topRow[0])
        .padding(24)
        .background(.backgroundBase)
}
