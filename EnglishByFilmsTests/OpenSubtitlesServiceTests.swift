//
//  OpenSubtitlesServiceTests.swift
//  EnglishByFilmsTests
//
//  Created by Mikalai Tsyhankou on 26/08/2026.
//

import Foundation
import Testing
@testable import EnglishByFilms

struct OpenSubtitlesServiceTests {
    private let host = "opensubtitles-\(UUID().uuidString.lowercased()).test"
    private let subtitleFileData = Data("1\n00:00:01,000 --> 00:00:02,000\nHello".utf8)

    // MARK: - Search

    @Test(arguments: [(0, 1), (1, 0), (-5, 1)])
    func rejectsInvalidSearchArguments(tmdbMovieID: Int, page: Int) async {
        await expectThrows(SubtitleServiceError.invalidRequest) {
            try await makeService().searchEnglishSubtitles(tmdbMovieID: tmdbMovieID, page: page)
        }
        #expect(URLProtocolStub.recordedRequests(forHost: host).isEmpty)
    }

    @Test func throwsWhenAPIKeyIsMissing() async {
        await expectThrows(SubtitleServiceError.missingAPIKey) {
            try await makeService(apiKey: "").searchEnglishSubtitles(tmdbMovieID: 1, page: 1)
        }
    }

    @Test func searchSendsExpectedRequest() async throws {
        stubSearchEndpoint()

        _ = try await makeService().searchEnglishSubtitles(tmdbMovieID: 27205, page: 2)

        let request = try #require(URLProtocolStub.recordedRequests(forHost: host).first)
        #expect(request.path == "/api/v1/subtitles")
        #expect(request.headers["Api-Key"] == "test-key")
        #expect(request.headers["User-Agent"] == "EnglishByFilmsTests v1.0")
        #expect(request.headers["Accept"] == "application/json")
        #expect(request.queryValue(for: "languages") == "en")
        #expect(request.queryValue(for: "tmdb_id") == "27205")
        #expect(request.queryValue(for: "page") == "2")
        #expect(request.queryValue(for: "type") == "movie")
        #expect(request.queryValue(for: "ai_translated") == "exclude")
        #expect(request.queryValue(for: "machine_translated") == "exclude")
        #expect(request.queryValue(for: "foreign_parts_only") == "exclude")
        #expect(request.queryValue(for: "order_by") == "new_download_count")
        #expect(request.queryValue(for: "order_direction") == "desc")
    }

    @Test func mapsSearchResponseToDomain() async throws {
        stubSearchEndpoint()

        let page = try await makeService().searchEnglishSubtitles(tmdbMovieID: 27205, page: 1)

        #expect(page.subtitles.map(\.fileID) == [42])
        #expect(page.subtitles.first?.fileName == "movie.srt")
        #expect(page.currentPage == 1)
        #expect(page.totalPages == 1)
    }

    @Test(arguments: [
        (400, SubtitleServiceError.invalidRequest),
        (401, SubtitleServiceError.unauthorized),
        (403, SubtitleServiceError.accessDenied),
        (404, SubtitleServiceError.unavailable),
        (406, SubtitleServiceError.downloadLimitReached),
        (422, SubtitleServiceError.invalidRequest),
        (429, SubtitleServiceError.rateLimited),
        (500, SubtitleServiceError.server(statusCode: 500))
    ])
    func mapsSearchHTTPErrors(statusCode: Int, expected: SubtitleServiceError) async {
        URLProtocolStub.setHandler(forHost: host) { _ in
            (statusCode, Data("{}".utf8))
        }

        await expectThrows(expected) {
            try await makeService().searchEnglishSubtitles(tmdbMovieID: 1, page: 1)
        }
    }

    @Test func throwsInvalidDataForMalformedSearchJSON() async {
        URLProtocolStub.setHandler(forHost: host) { _ in
            (200, Data("not json".utf8))
        }

        await expectThrows(SubtitleServiceError.invalidData) {
            try await makeService().searchEnglishSubtitles(tmdbMovieID: 1, page: 1)
        }
    }

    // MARK: - Download

    @Test func downloadsSubtitleFile() async throws {
        stubDownloadEndpoints()

        let subtitle = try await makeService().downloadSubtitle(fileID: 42)

        #expect(subtitle.fileName == "movie.srt")
        #expect(subtitle.data == subtitleFileData)
        #expect(subtitle.remainingDownloads == 41)
        #expect(subtitle.quotaResetDate == Date(timeIntervalSince1970: 1_787_824_800))

        let requests = URLProtocolStub.recordedRequests(forHost: host)
        #expect(requests.count == 2)

        let downloadRequest = try #require(requests.first)
        #expect(downloadRequest.path == "/api/v1/download")
        #expect(downloadRequest.httpMethod == "POST")
        #expect(downloadRequest.headers["Content-Type"] == "application/json")
        let body = try #require(downloadRequest.body)
        let bodyObject = try JSONSerialization.jsonObject(with: body) as? [String: Int]
        #expect(bodyObject == ["file_id": 42])

        let fileRequest = try #require(requests.last)
        #expect(fileRequest.path == "/files/movie.srt")
        #expect(fileRequest.headers["User-Agent"] == "EnglishByFilmsTests v1.0")
    }

    @Test func parsesQuotaResetDateWithoutFractionalSeconds() async throws {
        stubDownloadEndpoints(resetTimeUTC: "2026-08-27T10:00:00Z")

        let subtitle = try await makeService().downloadSubtitle(fileID: 42)

        #expect(subtitle.quotaResetDate == Date(timeIntervalSince1970: 1_787_824_800))
    }

    @Test func returnsNilQuotaResetDateWhenMissing() async throws {
        stubDownloadEndpoints(resetTimeUTC: nil)

        let subtitle = try await makeService().downloadSubtitle(fileID: 42)

        #expect(subtitle.quotaResetDate == nil)
    }

    @Test func rejectsNonHTTPSDownloadLink() async {
        stubDownloadEndpoints(link: "http://\(host)/files/movie.srt")

        await expectThrows(SubtitleServiceError.invalidResponse) {
            try await makeService().downloadSubtitle(fileID: 42)
        }
        #expect(URLProtocolStub.recordedRequests(forHost: host).count == 1)
    }

    @Test func throwsInvalidDataForEmptySubtitleFile() async {
        stubDownloadEndpoints(fileData: Data())

        await expectThrows(SubtitleServiceError.invalidData) {
            try await makeService().downloadSubtitle(fileID: 42)
        }
    }

    @Test(arguments: [
        (401, SubtitleServiceError.unavailable),
        (403, SubtitleServiceError.unavailable),
        (404, SubtitleServiceError.unavailable),
        (429, SubtitleServiceError.rateLimited),
        (500, SubtitleServiceError.server(statusCode: 500))
    ])
    func mapsSubtitleFileHTTPErrors(statusCode: Int, expected: SubtitleServiceError) async {
        stubDownloadEndpoints(fileStatusCode: statusCode)

        await expectThrows(expected) {
            try await makeService().downloadSubtitle(fileID: 42)
        }
    }

    @Test func rejectsInvalidDownloadFileID() async {
        await expectThrows(SubtitleServiceError.invalidRequest) {
            try await makeService().downloadSubtitle(fileID: 0)
        }
        #expect(URLProtocolStub.recordedRequests(forHost: host).isEmpty)
    }

    // MARK: - Private

    private func makeService(apiKey: String = "test-key") -> OpenSubtitlesService {
        let configuration = OpenSubtitlesConfiguration(
            baseURL: URL(string: "https://\(host)/api/v1")!,
            apiKey: apiKey,
            userAgent: "EnglishByFilmsTests v1.0"
        )

        return OpenSubtitlesService(
            configuration: configuration,
            session: URLProtocolStub.makeSession()
        )
    }

    private func stubSearchEndpoint() {
        let searchJSON = """
        {
            "total_pages": 1,
            "page": 1,
            "data": [
                {
                    "attributes": {
                        "language": "en",
                        "download_count": 100,
                        "new_download_count": 10,
                        "hearing_impaired": false,
                        "ratings": 8.5,
                        "from_trusted": true,
                        "foreign_parts_only": false,
                        "machine_translated": false,
                        "ai_translated": false,
                        "release": "Movie.2010.1080p",
                        "files": [{"file_id": 42, "file_name": "movie.srt"}]
                    }
                }
            ]
        }
        """

        URLProtocolStub.setHandler(forHost: host) { _ in
            (200, Data(searchJSON.utf8))
        }
    }

    private func stubDownloadEndpoints(
        link: String? = nil,
        resetTimeUTC: String? = "2026-08-27T10:00:00.000Z",
        fileStatusCode: Int = 200,
        fileData: Data? = nil
    ) {
        let fileLink = link ?? "https://\(host)/files/movie.srt"
        let resetField = resetTimeUTC.map { "\"\($0)\"" } ?? "null"
        let downloadJSON = """
        {
            "link": "\(fileLink)",
            "file_name": "movie.srt",
            "remaining": 41,
            "reset_time_utc": \(resetField)
        }
        """
        let responseFileData = fileData ?? subtitleFileData

        URLProtocolStub.setHandler(forHost: host) { request in
            if request.path == "/api/v1/download" {
                return (200, Data(downloadJSON.utf8))
            }

            return (fileStatusCode, responseFileData)
        }
    }
}
