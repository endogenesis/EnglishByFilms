//
//  LessonCueLineView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 27/08/2026.
//

import SwiftUI

struct LessonCueLineView: View {
    let text: String
    let distance: Int

    var body: some View {
        Text(text)
            .font(isActive ? .title2.weight(.semibold) : .subheadline)
            .foregroundStyle(color)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityHidden(!isActive)
    }

    private var isActive: Bool {
        distance == 0
    }

    private var color: Color {
        switch abs(distance) {
        case 0:
            .white
        case 1:
            Color(.textSecondary)
        default:
            Color(.textTertiary)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        LessonCueLineView(text: "Tumbling down the rabbit hole?", distance: -1)
        LessonCueLineView(text: "Do you believe in fate, Neo?", distance: 0)
        LessonCueLineView(text: "No.", distance: 1)
        LessonCueLineView(text: "Why not?", distance: 2)
    }
    .padding(24)
    .background(.backgroundBase)
    .preferredColorScheme(.dark)
}
