//
//  LessonFocusStageView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 27/08/2026.
//

import SwiftUI

struct LessonFocusStageView: View {
    let cues: [SubtitleCue]
    let activeIndex: Int

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private static let previousLineCount = 2
    private static let upcomingLineCount = 3

    var body: some View {
        Group {
            if cues.isEmpty {
                Text("No subtitles to display")
                    .font(.subheadline)
                    .foregroundStyle(.textSecondary)
            } else {
                VStack(spacing: 20) {
                    ForEach(visibleLines) { line in
                        if line.distance == 0 {
                            VStack(spacing: 14) {
                                LessonTimeBadgeView(time: line.cue.startTime)
                                LessonCueLineView(text: line.cue.text, distance: 0)
                            }
                            .accessibilityElement(children: .combine)
                        } else {
                            LessonCueLineView(text: line.cue.text, distance: line.distance)
                        }
                    }
                    .transition(.opacity)
                }
                .animation(reduceMotion ? nil : .snappy(duration: 0.35), value: activeIndex)
            }
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var visibleLines: [VisibleLine] {
        guard cues.indices.contains(activeIndex) else {
            return []
        }

        let lowerBound = max(activeIndex - Self.previousLineCount, 0)
        let upperBound = min(activeIndex + Self.upcomingLineCount, cues.count - 1)

        return (lowerBound...upperBound).map { index in
            VisibleLine(cue: cues[index], distance: index - activeIndex)
        }
    }
}

private struct VisibleLine: Identifiable {
    let cue: SubtitleCue
    let distance: Int

    var id: Int {
        cue.id
    }
}

#Preview {
    LessonFocusStageView(
        cues: PreviewSubtitleScript.theMatrix,
        activeIndex: 3
    )
    .background(.backgroundBase)
    .preferredColorScheme(.dark)
}
