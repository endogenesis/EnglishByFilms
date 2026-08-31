//
//  OnboardingStepIndicator.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 31/08/2026.
//

import SwiftUI

struct OnboardingStepIndicator: View {
    let currentIndex: Int
    let count: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(
                        index <= currentIndex
                            ? AnyShapeStyle(.accent)
                            : AnyShapeStyle(.white.opacity(0.12))
                    )
                    .frame(width: 40, height: 4)
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Step \(currentIndex + 1) of \(count)")
    }
}

#Preview {
    OnboardingStepIndicator(currentIndex: 0, count: 2)
        .padding(24)
        .background(.backgroundBase)
}
