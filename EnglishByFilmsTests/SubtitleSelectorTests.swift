//
//  SubtitleSelectorTests.swift
//  EnglishByFilmsTests
//
//  Created by Mikalai Tsyhankou on 26/08/2026.
//

import Testing
@testable import EnglishByFilms

struct SubtitleSelectorTests {
    private let selector = SubtitleSelector()

    // MARK: - Filtering

    @Test func returnsNilForEmptyList() {
        #expect(selector.selectBest(from: []) == nil)
    }

    @Test func excludesUnsupportedSubtitles() {
        let multiFile = SubtitleSummary.fixture(fileID: 1, fileCount: 2)
        let foreignPartsOnly = SubtitleSummary.fixture(fileID: 2, foreignPartsOnly: true)
        let machineTranslated = SubtitleSummary.fixture(fileID: 3, machineTranslated: true)
        let aiTranslated = SubtitleSummary.fixture(fileID: 4, aiTranslated: true)
        let supported = SubtitleSummary.fixture(fileID: 5)

        let best = selector.selectBest(
            from: [multiFile, foreignPartsOnly, machineTranslated, aiTranslated, supported]
        )

        #expect(best == supported)
    }

    @Test func returnsNilWhenAllSubtitlesAreUnsupported() {
        let subtitles = [
            SubtitleSummary.fixture(fileID: 1, fileCount: 0),
            SubtitleSummary.fixture(fileID: 2, machineTranslated: true),
            SubtitleSummary.fixture(fileID: 3, aiTranslated: true)
        ]

        #expect(selector.selectBest(from: subtitles) == nil)
    }

    // MARK: - Preference order

    @Test func prefersHigherNewDownloadCount() {
        let colder = SubtitleSummary.fixture(fileID: 1, downloadCount: 1_000, newDownloadCount: 10)
        let hotter = SubtitleSummary.fixture(fileID: 2, downloadCount: 5, newDownloadCount: 20)

        #expect(selector.selectBest(from: [colder, hotter]) == hotter)
    }

    @Test func breaksNewDownloadTieByTotalDownloads() {
        let lower = SubtitleSummary.fixture(fileID: 1, downloadCount: 100, newDownloadCount: 10)
        let higher = SubtitleSummary.fixture(fileID: 2, downloadCount: 200, newDownloadCount: 10)

        #expect(selector.selectBest(from: [lower, higher]) == higher)
    }

    @Test func breaksDownloadTieByTrustedSource() {
        let untrusted = SubtitleSummary.fixture(fileID: 1)
        let trusted = SubtitleSummary.fixture(fileID: 2, fromTrustedSource: true)

        #expect(selector.selectBest(from: [untrusted, trusted]) == trusted)
    }

    @Test func breaksTrustedTieByPreferringNonHearingImpaired() {
        let hearingImpaired = SubtitleSummary.fixture(fileID: 1, hearingImpaired: true)
        let regular = SubtitleSummary.fixture(fileID: 2)

        #expect(selector.selectBest(from: [hearingImpaired, regular]) == regular)
    }

    @Test func breaksHearingImpairedTieByRating() {
        let lowerRated = SubtitleSummary.fixture(fileID: 1, rating: 6.5)
        let higherRated = SubtitleSummary.fixture(fileID: 2, rating: 9.1)

        #expect(selector.selectBest(from: [lowerRated, higherRated]) == higherRated)
    }

    @Test func breaksFullTieByLowestFileID() {
        let newer = SubtitleSummary.fixture(fileID: 42)
        let older = SubtitleSummary.fixture(fileID: 7)

        #expect(selector.selectBest(from: [newer, older]) == older)
    }
}
