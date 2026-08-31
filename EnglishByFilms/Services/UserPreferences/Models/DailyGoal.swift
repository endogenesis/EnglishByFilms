//
//  DailyGoal.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 31/08/2026.
//

enum DailyGoal: String, CaseIterable {
    case casual
    case regular
    case serious

    var lessonsPerDay: Int {
        switch self {
        case .casual: 1
        case .regular: 3
        case .serious: 5
        }
    }

    var estimatedMinutesPerDay: Int {
        switch self {
        case .casual: 10
        case .regular: 30
        case .serious: 50
        }
    }
}
