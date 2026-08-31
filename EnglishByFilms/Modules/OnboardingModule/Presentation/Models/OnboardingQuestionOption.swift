//
//  OnboardingQuestionOption.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 31/08/2026.
//

struct OnboardingQuestionOption<Value: Hashable>: Identifiable {
    let value: Value
    let title: String
    let subtitle: String

    var id: Value { value }
}
