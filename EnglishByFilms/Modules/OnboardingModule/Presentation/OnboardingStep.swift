//
//  OnboardingStep.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 31/08/2026.
//

enum OnboardingStep: CaseIterable {
    case welcome
    case level
    case goal

    var questionIndex: Int? {
        switch self {
        case .welcome: nil
        case .level: 0
        case .goal: 1
        }
    }

    static var questionCount: Int {
        allCases.count { $0.questionIndex != nil }
    }
}
