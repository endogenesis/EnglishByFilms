//
//  PreviewUserPreferencesStore.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 31/08/2026.
//

final class PreviewUserPreferencesStore: UserPreferencesStore {
    private(set) var isOnboardingCompleted: Bool
    private(set) var englishLevel: EnglishLevel
    private(set) var dailyGoal: DailyGoal

    init(
        isOnboardingCompleted: Bool = false,
        englishLevel: EnglishLevel = .intermediate,
        dailyGoal: DailyGoal = .regular
    ) {
        self.isOnboardingCompleted = isOnboardingCompleted
        self.englishLevel = englishLevel
        self.dailyGoal = dailyGoal
    }

    func completeOnboarding(englishLevel: EnglishLevel, dailyGoal: DailyGoal) {
        self.englishLevel = englishLevel
        self.dailyGoal = dailyGoal
        isOnboardingCompleted = true
    }
}
