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
            data: Data(Self.previewSRT.utf8),
            remainingDownloads: 4,
            quotaResetDate: nil
        )
    }

    private static let previewSRT = """
    1
    00:26:34,000 --> 00:26:37,200
    I imagine you're feeling a bit like Alice.

    2
    00:26:37,600 --> 00:26:39,400
    Tumbling down the rabbit hole?

    3
    00:26:39,800 --> 00:26:41,200
    Hm. You could say that.

    4
    00:26:41,900 --> 00:26:44,000
    Do you believe in fate, Neo?
    """
}
