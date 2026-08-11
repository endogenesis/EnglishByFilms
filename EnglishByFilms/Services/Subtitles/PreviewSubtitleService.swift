//
//  PreviewSubtitleService.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 12/08/2026.
//

import Foundation

struct PreviewSubtitleService: SubtitleService {
    private let subtitle = SubtitleSummary(
        fileID: 1,
        fileName: "The.Matrix.1999.en.srt",
        releaseName: "The.Matrix.1999.1080p.BluRay",
        languageCode: "en",
        downloadCount: 1_000,
        newDownloadCount: 250,
        rating: 9,
        hearingImpaired: false,
        fromTrustedSource: true,
        foreignPartsOnly: false,
        machineTranslated: false,
        aiTranslated: false,
        fileCount: 1
    )

    func searchEnglishSubtitles(tmdbMovieID: Int, page: Int) async throws -> SubtitlePage {
        SubtitlePage(
            subtitles: [subtitle],
            currentPage: page,
            totalPages: 1
        )
    }

    func downloadSubtitle(fileID: Int) async throws -> DownloadedSubtitle {
        DownloadedSubtitle(
            fileName: subtitle.fileName,
            data: Data(),
            remainingDownloads: 4,
            quotaResetDate: nil
        )
    }
}
