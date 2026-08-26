//
//  TestFixtures.swift
//  EnglishByFilmsTests
//
//  Created by Mikalai Tsyhankou on 26/08/2026.
//

import Foundation
@testable import EnglishByFilms

extension MovieSummary {
    static func fixture(
        id: Int = 1,
        title: String = "Inception",
        originalTitle: String = "Inception",
        overview: String = "A thief enters dreams.",
        releaseYear: Int? = 2010,
        posterURL: URL? = nil,
        rating: Double = 8.4,
        genres: [String] = ["Action"]
    ) -> MovieSummary {
        MovieSummary(
            id: id,
            title: title,
            originalTitle: originalTitle,
            overview: overview,
            releaseYear: releaseYear,
            posterURL: posterURL,
            rating: rating,
            genres: genres
        )
    }
}

extension MoviePage {
    static func fixture(
        movies: [MovieSummary] = [.fixture()],
        currentPage: Int = 1,
        totalPages: Int = 1
    ) -> MoviePage {
        MoviePage(movies: movies, currentPage: currentPage, totalPages: totalPages)
    }
}

extension MovieDetails {
    static func fixture(
        id: Int = 1,
        title: String = "Inception",
        overview: String = "A thief enters dreams.",
        releaseYear: Int? = 2010,
        runtimeMinutes: Int? = 148,
        backdropURL: URL? = nil,
        rating: Double = 8.4,
        genres: [String] = ["Action"]
    ) -> MovieDetails {
        MovieDetails(
            id: id,
            title: title,
            overview: overview,
            releaseYear: releaseYear,
            runtimeMinutes: runtimeMinutes,
            backdropURL: backdropURL,
            rating: rating,
            genres: genres
        )
    }
}

extension SubtitleSummary {
    static func fixture(
        fileID: Int = 1,
        fileName: String = "subtitle.srt",
        releaseName: String = "Movie.2010.1080p",
        languageCode: String = "en",
        downloadCount: Int = 0,
        newDownloadCount: Int = 0,
        rating: Double = 0,
        hearingImpaired: Bool = false,
        fromTrustedSource: Bool = false,
        foreignPartsOnly: Bool = false,
        machineTranslated: Bool = false,
        aiTranslated: Bool = false,
        fileCount: Int = 1
    ) -> SubtitleSummary {
        SubtitleSummary(
            fileID: fileID,
            fileName: fileName,
            releaseName: releaseName,
            languageCode: languageCode,
            downloadCount: downloadCount,
            newDownloadCount: newDownloadCount,
            rating: rating,
            hearingImpaired: hearingImpaired,
            fromTrustedSource: fromTrustedSource,
            foreignPartsOnly: foreignPartsOnly,
            machineTranslated: machineTranslated,
            aiTranslated: aiTranslated,
            fileCount: fileCount
        )
    }
}

extension SubtitlePage {
    static func fixture(
        subtitles: [SubtitleSummary] = [.fixture()],
        currentPage: Int = 1,
        totalPages: Int = 1
    ) -> SubtitlePage {
        SubtitlePage(subtitles: subtitles, currentPage: currentPage, totalPages: totalPages)
    }
}

extension DownloadedSubtitle {
    static func fixture(
        fileName: String = "subtitle.srt",
        data: Data = Data("1\n00:00:01,000 --> 00:00:02,000\nHello".utf8),
        remainingDownloads: Int = 10,
        quotaResetDate: Date? = nil
    ) -> DownloadedSubtitle {
        DownloadedSubtitle(
            fileName: fileName,
            data: data,
            remainingDownloads: remainingDownloads,
            quotaResetDate: quotaResetDate
        )
    }
}
