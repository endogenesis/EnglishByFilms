//
//  OnboardingOptionCard.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 31/08/2026.
//

import SwiftUI

struct OnboardingOptionCard: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.callout.weight(.semibold))
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundStyle(.textSecondary)
                }

                Spacer(minLength: 0)

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.callout.bold())
                        .foregroundStyle(.accent)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(
                isSelected
                    ? AnyShapeStyle(.accent.opacity(0.13))
                    : AnyShapeStyle(.glassFill),
                in: .rect(cornerRadius: 16)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(.accent, lineWidth: 1)
                    .opacity(isSelected ? 1 : 0)
            )
            .contentShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    VStack(spacing: 12) {
        OnboardingOptionCard(
            title: "Beginner",
            subtitle: "A1–A2 · simple dialogues",
            isSelected: false,
            action: { }
        )
        OnboardingOptionCard(
            title: "Intermediate",
            subtitle: "B1–B2 · everyday speech",
            isSelected: true,
            action: { }
        )
    }
    .padding(24)
    .background(.backgroundBase)
}
