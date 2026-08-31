//
//  OnboardingView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 31/08/2026.
//

import SwiftUI

struct OnboardingView: View {
    @State private var viewModel: OnboardingViewModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(viewModel: OnboardingViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            switch viewModel.step {
            case .welcome:
                OnboardingWelcomeView(
                    getStarted: viewModel.advance,
                    skip: viewModel.skipPersonalization
                )
                .transition(stepTransition)
            case .level:
                OnboardingQuestionStepView(
                    questionIndex: 0,
                    questionCount: OnboardingStep.questionCount,
                    title: "What’s your English level?",
                    hint: "We’ll match movies to your level — you can change it anytime.",
                    options: viewModel.levelOptions,
                    selection: $viewModel.selectedLevel,
                    continueAction: viewModel.advance
                )
                .transition(stepTransition)
            case .goal:
                OnboardingQuestionStepView(
                    questionIndex: 1,
                    questionCount: OnboardingStep.questionCount,
                    title: "Set your daily goal",
                    hint: "Small daily wins keep your streak alive. You can change this anytime.",
                    options: viewModel.goalOptions,
                    selection: $viewModel.selectedGoal,
                    continueAction: viewModel.advance
                )
                .transition(stepTransition)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.step)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.backgroundBase)
    }

    private var stepTransition: AnyTransition {
        reduceMotion ? .opacity : .push(from: .trailing)
    }
}

#Preview {
    OnboardingModuleBuilder.build(
        userPreferencesStore: PreviewUserPreferencesStore(),
        onFinish: { }
    )
}
