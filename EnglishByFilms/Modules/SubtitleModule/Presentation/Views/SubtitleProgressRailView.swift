//
//  SubtitleProgressRailView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 29/08/2026.
//

import SwiftUI

struct SubtitleProgressRailView: View {
    let progress: Double
    let progressStep: Double
    let updateProgress: (Double) -> Void

    private static let knobDiameter: CGFloat = 10
    private static let trackWidth: CGFloat = 2
    private static let maximumHeight: CGFloat = 440
    private static let interactionWidth: CGFloat = 44

    var body: some View {
        GeometryReader { proxy in
            let travelDistance = max(proxy.size.height - Self.knobDiameter, 0)

            ZStack(alignment: .top) {
                Capsule()
                    .fill(.glassBorder)
                    .frame(width: Self.trackWidth)
                    .frame(maxWidth: .infinity)

                Circle()
                    .fill(.accent)
                    .frame(width: Self.knobDiameter, height: Self.knobDiameter)
                    .offset(y: travelDistance * CGFloat(clampedProgress))
            }
            .contentShape(.rect)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        updateProgress(
                            progress(at: value.location.y, travelDistance: travelDistance)
                        )
                    }
            )
        }
        .frame(width: Self.interactionWidth)
        .frame(maxHeight: Self.maximumHeight)
        .accessibilityElement()
        .accessibilityLabel("Subtitle position")
        .accessibilityValue(
            Text(clampedProgress, format: .percent.precision(.fractionLength(0)))
        )
        .accessibilityHint("Adjust to move quickly through the subtitles.")
        .accessibilityAdjustableAction(adjustProgress)
    }

    private var clampedProgress: Double {
        min(max(progress, 0), 1)
    }

    private func progress(at location: CGFloat, travelDistance: CGFloat) -> Double {
        guard travelDistance > 0 else {
            return 0
        }

        let knobOrigin = location - Self.knobDiameter / 2
        return min(max(Double(knobOrigin / travelDistance), 0), 1)
    }

    private func adjustProgress(_ direction: AccessibilityAdjustmentDirection) {
        switch direction {
        case .increment:
            updateProgress(min(clampedProgress + progressStep, 1))
        case .decrement:
            updateProgress(max(clampedProgress - progressStep, 0))
        @unknown default:
            break
        }
    }
}

#Preview {
    @Previewable @State var progress = 0.3

    SubtitleProgressRailView(
        progress: progress,
        progressStep: 0.05,
        updateProgress: { progress = $0 }
    )
        .padding(24)
        .background(.backgroundBase)
        .preferredColorScheme(.dark)
}
