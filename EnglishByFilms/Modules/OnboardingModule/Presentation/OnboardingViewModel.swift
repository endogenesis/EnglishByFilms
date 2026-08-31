//
//  OnboardingViewModel.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 31/08/2026.
//

import Observation

@Observable
final class OnboardingViewModel {
    private(set) var step: OnboardingStep = .welcome
    var selectedLevel: EnglishLevel = .intermediate
    var selectedGoal: DailyGoal = .regular

    var levelOptions: [OnboardingQuestionOption<EnglishLevel>] {
        EnglishLevel.allCases.map { level in
            OnboardingQuestionOption(
                value: level,
                title: Self.title(for: level),
                subtitle: Self.subtitle(for: level)
            )
        }
    }

    var goalOptions: [OnboardingQuestionOption<DailyGoal>] {
        DailyGoal.allCases.map { goal in
            OnboardingQuestionOption(
                value: goal,
                title: Self.title(for: goal),
                subtitle: Self.subtitle(for: goal)
            )
        }
    }

    private let userPreferencesStore: UserPreferencesStore
    private let onFinish: () -> Void

    init(
        userPreferencesStore: UserPreferencesStore,
        onFinish: @escaping () -> Void
    ) {
        self.userPreferencesStore = userPreferencesStore
        self.onFinish = onFinish
    }

    func advance() {
        switch step {
        case .welcome:
            step = .level
        case .level:
            step = .goal
        case .goal:
            finish()
        }
    }

    func skipPersonalization() {
        finish()
    }

    // MARK: - Private

    private func finish() {
        userPreferencesStore.completeOnboarding(
            englishLevel: selectedLevel,
            dailyGoal: selectedGoal
        )
        onFinish()
    }

    private static func title(for level: EnglishLevel) -> String {
        switch level {
        case .beginner: "Beginner"
        case .intermediate: "Intermediate"
        case .upperIntermediate: "Upper-Intermediate"
        case .advanced: "Advanced"
        }
    }

    private static func subtitle(for level: EnglishLevel) -> String {
        switch level {
        case .beginner: "A1–A2 · simple dialogues"
        case .intermediate: "B1–B2 · everyday speech"
        case .upperIntermediate: "B2–C1 · fast native dialogue"
        case .advanced: "C1+ · slang and idioms"
        }
    }

    private static func title(for goal: DailyGoal) -> String {
        switch goal {
        case .casual: "Casual"
        case .regular: "Regular"
        case .serious: "Serious"
        }
    }

    private static func subtitle(for goal: DailyGoal) -> String {
        let lessons = goal.lessonsPerDay == 1 ? "lesson" : "lessons"
        return "\(goal.lessonsPerDay) \(lessons) a day · ~\(goal.estimatedMinutesPerDay) min"
    }
}
