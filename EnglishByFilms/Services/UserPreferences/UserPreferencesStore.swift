//
//  UserPreferencesStore.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 31/08/2026.
//

protocol UserPreferencesStore: AnyObject {
    var isOnboardingCompleted: Bool { get }
    var englishLevel: EnglishLevel { get }
    var dailyGoal: DailyGoal { get }

    func completeOnboarding(englishLevel: EnglishLevel, dailyGoal: DailyGoal)
}
