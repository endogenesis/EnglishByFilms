//
//  OnboardingPoster.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 31/08/2026.
//

import SwiftUI

struct OnboardingPoster: Identifiable {
    let title: String
    let topGlowColor: Color
    let bottomGlowColor: Color

    var id: String { title }
}

extension OnboardingPoster {
    static let topRow = [
        OnboardingPoster(
            title: "PARADOX",
            topGlowColor: Color(hex: 0x1C5A82),
            bottomGlowColor: Color(hex: 0x0C1E45)
        ),
        OnboardingPoster(
            title: "RED HORIZON",
            topGlowColor: Color(hex: 0xB34E1E),
            bottomGlowColor: Color(hex: 0x571E0C)
        ),
        OnboardingPoster(
            title: "NIGHT DRIVE",
            topGlowColor: Color(hex: 0x8A1E7E),
            bottomGlowColor: Color(hex: 0x2A0C50)
        ),
        OnboardingPoster(
            title: "CIPHER",
            topGlowColor: Color(hex: 0x0E5A2E),
            bottomGlowColor: Color(hex: 0x06200E)
        )
    ]

    static let bottomRow = [
        OnboardingPoster(
            title: "GOLDEN AGE",
            topGlowColor: Color(hex: 0x9A7228),
            bottomGlowColor: Color(hex: 0x302008)
        ),
        OnboardingPoster(
            title: "PLUS ONE",
            topGlowColor: Color(hex: 0xC05A80),
            bottomGlowColor: Color(hex: 0x401428)
        ),
        OnboardingPoster(
            title: "POLARIS",
            topGlowColor: Color(hex: 0x3E7EA6),
            bottomGlowColor: Color(hex: 0x0E2038)
        ),
        OnboardingPoster(
            title: "ROOMMATES",
            topGlowColor: Color(hex: 0x6E8824),
            bottomGlowColor: Color(hex: 0x1C2408)
        )
    ]
}

private extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}
