//
//  LessonHeaderView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 27/08/2026.
//

import SwiftUI

struct LessonHeaderView: View {
    let movieTitle: String
    let currentTime: Duration?

    var body: some View {
        VStack(spacing: 2) {
            Text(movieTitle)
                .font(.headline)

            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.textTertiary)
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .accessibilityElement(children: .combine)
    }

    private var subtitle: String {
        guard let currentTime else {
            return String(localized: "Focus")
        }

        let time = currentTime.formatted(.time(pattern: .hourMinuteSecond))
        return String(localized: "Focus · \(time)")
    }
}

#Preview {
    LessonHeaderView(movieTitle: "The Matrix", currentTime: .seconds(1_601))
        .background(.backgroundBase)
        .preferredColorScheme(.dark)
}
