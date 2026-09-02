//
//  SubtitleTimeBadgeView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 29/08/2026.
//

import Foundation
import SwiftUI

struct SubtitleTimeBadgeView: View {
    let time: TimeInterval

    var body: some View {
        Text(Duration.seconds(time).formatted(.time(pattern: .hourMinuteSecond)))
            .font(.caption)
            .bold()
            .monospacedDigit()
            .foregroundStyle(.accent)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(.accent.opacity(0.12), in: .capsule)
    }
}

#Preview {
    SubtitleTimeBadgeView(time: 1_601)
        .padding(24)
        .background(.backgroundBase)
        .preferredColorScheme(.dark)
}
