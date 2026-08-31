//
//  OnboardingWelcomeView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 31/08/2026.
//

import SwiftUI

struct OnboardingWelcomeView: View {
    let getStarted: () -> Void
    let skip: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            OnboardingPosterCollageView()
                .padding(.top, 8)

            VStack(alignment: .leading, spacing: 0) {
                Text("Learn English from movies you love")
                    .font(.largeTitle.bold())
                    .padding(.top, 40)

                Text("Watch anywhere. Then open Replay — we turn the subtitles into 10-minute lessons with real phrases.")
                    .font(.callout)
                    .foregroundStyle(.textSecondary)
                    .padding(.top, 16)

                Spacer(minLength: 32)

                PrimaryButton("Get started", action: getStarted)

                Button("I already have an account", action: skip)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.textSecondary)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .padding(.bottom, 4)
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    OnboardingWelcomeView(getStarted: { }, skip: { })
        .background(.backgroundBase)
}
