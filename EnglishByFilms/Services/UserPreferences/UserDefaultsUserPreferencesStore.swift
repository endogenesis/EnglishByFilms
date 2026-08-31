//
//  UserDefaultsUserPreferencesStore.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 31/08/2026.
//

import Foundation

final class UserDefaultsUserPreferencesStore: UserPreferencesStore {
    private enum Key {
        static let isOnboardingCompleted = "preferences.isOnboardingCompleted"
        static let englishLevel = "preferences.englishLevel"
        static let dailyGoal = "preferences.dailyGoal"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var isOnboardingCompleted: Bool {
        defaults.bool(forKey: Key.isOnboardingCompleted)
    }

    var englishLevel: EnglishLevel {
        defaults.string(forKey: Key.englishLevel)
            .flatMap { EnglishLevel(rawValue: $0) } ?? .intermediate
    }

    var dailyGoal: DailyGoal {
        defaults.string(forKey: Key.dailyGoal)
            .flatMap { DailyGoal(rawValue: $0) } ?? .regular
    }

    func completeOnboarding(englishLevel: EnglishLevel, dailyGoal: DailyGoal) {
        defaults.set(englishLevel.rawValue, forKey: Key.englishLevel)
        defaults.set(dailyGoal.rawValue, forKey: Key.dailyGoal)
        defaults.set(true, forKey: Key.isOnboardingCompleted)
    }
}
