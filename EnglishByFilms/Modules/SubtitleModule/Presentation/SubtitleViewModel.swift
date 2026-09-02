//
//  SubtitleViewModel.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 29/08/2026.
//

import Observation

@MainActor
@Observable
final class SubtitleViewModel {
    private(set) var state = SubtitleViewState()

    let movieTitle: String
    let subtitles: SubtitleDocument

    init(movieTitle: String, subtitles: SubtitleDocument) {
        self.movieTitle = movieTitle
        self.subtitles = subtitles
    }

    var entries: [SubtitleEntry] {
        subtitles.entries
    }

    var activeEntry: SubtitleEntry? {
        entries.indices.contains(state.activeEntryIndex) ? entries[state.activeEntryIndex] : nil
    }

    var progress: Double {
        entries.count > 1 ? Double(state.activeEntryIndex) / Double(entries.count - 1) : 0
    }

    var progressStep: Double {
        entries.count > 1 ? 1 / Double(entries.count - 1) : 1
    }

    func selectEntry(at index: Int) {
        guard !entries.isEmpty else {
            return
        }

        state.activeEntryIndex = min(max(index, 0), entries.count - 1)
    }

    func selectEntry(atProgress progress: Double) {
        guard entries.count > 1 else {
            selectEntry(at: 0)
            return
        }

        let clampedProgress = min(max(progress, 0), 1)
        let index = Int((clampedProgress * Double(entries.count - 1)).rounded())
        selectEntry(at: index)
    }
}
