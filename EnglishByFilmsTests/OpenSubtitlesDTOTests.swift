//
//  OpenSubtitlesDTOTests.swift
//  EnglishByFilmsTests
//
//  Created by Mikalai Tsyhankou on 26/08/2026.
//

import Foundation
import Testing
@testable import EnglishByFilms

struct OpenSubtitlesDTOTests {
    @Test func decodesAndMapsSearchResponse() throws {
        let json = """
        {
            "total_pages": 4,
            "page": 2,
            "data": [
                {
                    "attributes": {
                        "language": "en",
                        "download_count": 100,
                        "new_download_count": 10,
                        "hearing_impaired": true,
                        "ratings": 8.5,
                        "from_trusted": true,
                        "foreign_parts_only": false,
                        "machine_translated": false,
                        "ai_translated": false,
                        "release": "Movie.2010.1080p",
                        "files": [
                            {"file_id": 42, "file_name": "movie.srt"}
                        ]
                    }
                }
            ]
        }
        """

        let dto = try JSONDecoder().decode(
            OpenSubtitlesSearchResponseDTO.self,
            from: Data(json.utf8)
        )
        let page = dto.toDomain()

        #expect(page == SubtitlePage(
            subtitles: [
                SubtitleSummary(
                    fileID: 42,
                    fileName: "movie.srt",
                    releaseName: "Movie.2010.1080p",
                    languageCode: "en",
                    downloadCount: 100,
                    newDownloadCount: 10,
                    rating: 8.5,
                    hearingImpaired: true,
                    fromTrustedSource: true,
                    foreignPartsOnly: false,
                    machineTranslated: false,
                    aiTranslated: false,
                    fileCount: 1
                )
            ],
            currentPage: 2,
            totalPages: 4
        ))
    }

    @Test func skipsFilesWithoutValidIDOrName() throws {
        let json = """
        {
            "total_pages": 1,
            "page": 1,
            "data": [
                {
                    "attributes": {
                        "language": "en",
                        "files": [
                            {"file_id": 0, "file_name": "zero.srt"},
                            {"file_id": null, "file_name": "missing-id.srt"},
                            {"file_id": 7},
                            {"file_id": 42, "file_name": "valid.srt"}
                        ]
                    }
                }
            ]
        }
        """

        let page = try JSONDecoder()
            .decode(OpenSubtitlesSearchResponseDTO.self, from: Data(json.utf8))
            .toDomain()

        #expect(page.subtitles.map(\.fileID) == [42])
        #expect(page.subtitles.first?.fileCount == 4)
    }

    @Test func appliesDefaultsForMissingAttributes() throws {
        let json = """
        {
            "total_pages": 1,
            "page": 1,
            "data": [
                {
                    "attributes": {
                        "files": [{"file_id": 42, "file_name": "movie.srt"}]
                    }
                }
            ]
        }
        """

        let page = try JSONDecoder()
            .decode(OpenSubtitlesSearchResponseDTO.self, from: Data(json.utf8))
            .toDomain()
        let subtitle = try #require(page.subtitles.first)

        #expect(subtitle.releaseName == "movie.srt")
        #expect(subtitle.languageCode == "")
        #expect(subtitle.downloadCount == 0)
        #expect(subtitle.newDownloadCount == 0)
        #expect(subtitle.rating == 0)
        #expect(!subtitle.hearingImpaired)
        #expect(!subtitle.fromTrustedSource)
        #expect(!subtitle.foreignPartsOnly)
        #expect(!subtitle.machineTranslated)
        #expect(!subtitle.aiTranslated)
    }

    @Test func splitsMultiFileEntryIntoSeparateSummaries() throws {
        let json = """
        {
            "total_pages": 1,
            "page": 1,
            "data": [
                {
                    "attributes": {
                        "language": "en",
                        "files": [
                            {"file_id": 1, "file_name": "part1.srt"},
                            {"file_id": 2, "file_name": "part2.srt"}
                        ]
                    }
                }
            ]
        }
        """

        let page = try JSONDecoder()
            .decode(OpenSubtitlesSearchResponseDTO.self, from: Data(json.utf8))
            .toDomain()

        #expect(page.subtitles.map(\.fileID) == [1, 2])
        #expect(page.subtitles.map(\.fileCount) == [2, 2])
    }

    @Test func decodesDownloadResponse() throws {
        let json = """
        {
            "link": "https://files.test/movie.srt",
            "file_name": "movie.srt",
            "remaining": 41,
            "reset_time_utc": "2026-08-27T10:00:00.000Z"
        }
        """

        let dto = try JSONDecoder().decode(
            OpenSubtitlesDownloadResponseDTO.self,
            from: Data(json.utf8)
        )

        #expect(dto.link == URL(string: "https://files.test/movie.srt"))
        #expect(dto.fileName == "movie.srt")
        #expect(dto.remainingDownloads == 41)
        #expect(dto.resetTimeUTC == "2026-08-27T10:00:00.000Z")
    }

    @Test func encodesDownloadRequestWithSnakeCaseFileID() throws {
        let data = try JSONEncoder().encode(OpenSubtitlesDownloadRequestDTO(fileID: 42))
        let object = try JSONSerialization.jsonObject(with: data) as? [String: Int]

        #expect(object == ["file_id": 42])
    }
}
