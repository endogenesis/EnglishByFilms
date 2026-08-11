//
//  SubtitleSelector.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 12/08/2026.
//

struct SubtitleSelector {
    func selectBest(from subtitles: [SubtitleSummary]) -> SubtitleSummary? {
        let supportedSubtitles = subtitles.filter(isSupported)
        return supportedSubtitles.sorted(by: isPreferred).first
    }

    // MARK: - Private

    private func isSupported(_ subtitle: SubtitleSummary) -> Bool {
        subtitle.fileCount == 1
            && !subtitle.foreignPartsOnly
            && !subtitle.machineTranslated
            && !subtitle.aiTranslated
    }

    private func isPreferred(_ lhs: SubtitleSummary, _ rhs: SubtitleSummary) -> Bool {
        if lhs.newDownloadCount != rhs.newDownloadCount {
            return lhs.newDownloadCount > rhs.newDownloadCount
        }

        if lhs.downloadCount != rhs.downloadCount {
            return lhs.downloadCount > rhs.downloadCount
        }

        if lhs.fromTrustedSource != rhs.fromTrustedSource {
            return lhs.fromTrustedSource
        }

        if lhs.hearingImpaired != rhs.hearingImpaired {
            return !lhs.hearingImpaired
        }

        if lhs.rating != rhs.rating {
            return lhs.rating > rhs.rating
        }

        return lhs.fileID < rhs.fileID
    }
}
