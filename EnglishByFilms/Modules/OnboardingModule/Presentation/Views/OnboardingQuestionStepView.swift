//
//  OnboardingQuestionStepView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 31/08/2026.
//

import SwiftUI

struct OnboardingQuestionStepView<Value: Hashable>: View {
    let questionIndex: Int
    let questionCount: Int
    let title: String
    let hint: String
    let options: [OnboardingQuestionOption<Value>]
    @Binding var selection: Value
    let continueAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            OnboardingStepIndicator(
                currentIndex: questionIndex,
                count: questionCount
            )
            .padding(.top, 12)

            Text(title)
                .font(.title.bold())
                .padding(.top, 32)

            Text(hint)
                .font(.subheadline)
                .foregroundStyle(.textSecondary)
                .padding(.top, 8)

            VStack(spacing: 12) {
                ForEach(options) { option in
                    OnboardingOptionCard(
                        title: option.title,
                        subtitle: option.subtitle,
                        isSelected: selection == option.value
                    ) {
                        selection = option.value
                    }
                }
            }
            .padding(.top, 32)
            .animation(.easeInOut(duration: 0.15), value: selection)

            Spacer(minLength: 24)

            PrimaryButton("Continue", action: continueAction)
                .padding(.bottom, 12)
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    @Previewable @State var selection: EnglishLevel = .intermediate

    OnboardingQuestionStepView(
        questionIndex: 0,
        questionCount: 2,
        title: "What’s your English level?",
        hint: "We’ll match movies to your level — you can change it anytime.",
        options: [
            OnboardingQuestionOption(
                value: EnglishLevel.beginner,
                title: "Beginner",
                subtitle: "A1–A2 · simple dialogues"
            ),
            OnboardingQuestionOption(
                value: EnglishLevel.intermediate,
                title: "Intermediate",
                subtitle: "B1–B2 · everyday speech"
            )
        ],
        selection: $selection,
        continueAction: { }
    )
    .background(.backgroundBase)
}
