//
//  LessonViewModel.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 27/08/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class LessonViewModel {
    private(set) var activeIndex = 0

    let movieTitle: String
    let cues: [SubtitleCue]

    private let clock = ContinuousClock()

    private static let minimumLineDuration = Duration.seconds(1)
    private static let maximumPause = Duration.seconds(2)

    init(movieTitle: String, cues: [SubtitleCue]) {
        self.movieTitle = movieTitle
        self.cues = cues
    }

    var activeCue: SubtitleCue? {
        cues.indices.contains(activeIndex) ? cues[activeIndex] : nil
    }

    var progress: Double {
        guard let activeCue, let firstCue = cues.first, let lastCue = cues.last else {
            return 0
        }

        let total = lastCue.endTime - firstCue.startTime
        guard total > .zero else {
            return 0
        }

        return min(max((activeCue.startTime - firstCue.startTime) / total, 0), 1)
    }

    func autoAdvance() async {
        while activeIndex < cues.count - 1 {
            let current = cues[activeIndex]
            let next = cues[activeIndex + 1]

            do {
                try await clock.sleep(for: displayDuration(current: current, next: next))
            } catch {
                return
            }

            activeIndex += 1
        }
    }

    private func displayDuration(current: SubtitleCue, next: SubtitleCue) -> Duration {
        // Follow the film's own pacing, but never flash a line too briefly
        // and collapse long silent gaps between cues.
        let line = max(current.endTime - current.startTime, Self.minimumLineDuration)
        let pause = min(max(next.startTime - current.endTime, .zero), Self.maximumPause)

        return line + pause
    }
}
