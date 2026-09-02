//
//  SubtitleHeaderView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 29/08/2026.
//

import Foundation
import SwiftUI

struct SubtitleHeaderView: View {
    let movieTitle: String
    let currentTime: TimeInterval?

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
            return String(localized: "Subtitles")
        }

        let time = Duration.seconds(currentTime).formatted(.time(pattern: .hourMinuteSecond))
        return String(localized: "Subtitles · \(time)")
    }
}

#Preview {
    SubtitleHeaderView(movieTitle: "The Matrix", currentTime: 1_601)
        .background(.backgroundBase)
        .preferredColorScheme(.dark)
}
