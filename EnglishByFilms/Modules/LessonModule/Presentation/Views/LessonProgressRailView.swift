//
//  LessonProgressRailView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 27/08/2026.
//

import SwiftUI

struct LessonProgressRailView: View {
    let progress: Double

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private static let knobDiameter: CGFloat = 10
    private static let trackWidth: CGFloat = 2
    private static let maximumHeight: CGFloat = 440

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                Capsule()
                    .fill(.glassBorder)
                    .frame(width: Self.trackWidth)
                    .frame(maxWidth: .infinity)

                Circle()
                    .fill(.accent)
                    .frame(width: Self.knobDiameter, height: Self.knobDiameter)
                    .offset(y: (proxy.size.height - Self.knobDiameter) * progress)
            }
        }
        .frame(width: Self.knobDiameter)
        .frame(maxHeight: Self.maximumHeight)
        .animation(reduceMotion ? nil : .snappy(duration: 0.35), value: progress)
        .accessibilityHidden(true)
    }
}

#Preview {
    LessonProgressRailView(progress: 0.3)
        .padding(24)
        .background(.backgroundBase)
        .preferredColorScheme(.dark)
}
