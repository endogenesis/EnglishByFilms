//
//  LessonTimeBadgeView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 27/08/2026.
//

import SwiftUI

struct LessonTimeBadgeView: View {
    let time: Duration

    var body: some View {
        Text(time.formatted(.time(pattern: .hourMinuteSecond)))
            .font(.caption.weight(.semibold))
            .monospacedDigit()
            .foregroundStyle(.accent)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(.accent.opacity(0.12), in: .capsule)
    }
}

#Preview {
    LessonTimeBadgeView(time: .seconds(1_601))
        .padding(24)
        .background(.backgroundBase)
        .preferredColorScheme(.dark)
}
