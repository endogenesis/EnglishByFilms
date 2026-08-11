//
//  OpenSubtitlesService.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 11/08/2026.
//

import Foundation

actor OpenSubtitlesService: SubtitleService {
    private let configuration: OpenSubtitlesConfiguration
    private let session: URLSession

    private struct ErrorResponse: Decodable {
        let message: String?
    }

    private enum Endpoint: String {
        case subtitles
        case download
    }

    init(configuration: OpenSubtitlesConfiguration, session: URLSession = .shared) {
        self.configuration = configuration
        self.session = session
    }

    func searchEnglishSubtitles(tmdbMovieID: Int, page: Int) async throws -> SubtitlePage {
        guard tmdbMovieID > 0, page > 0 else {
            throw SubtitleServiceError.invalidRequest
        }

        let request = try makeRequest(
            endpoint: .subtitles,
            queryItems: [
                URLQueryItem(name: "ai_translated", value: "exclude"),
                URLQueryItem(name: "foreign_parts_only", value: "exclude"),
                URLQueryItem(name: "languages", value: "en"),
                URLQueryItem(name: "machine_translated", value: "exclude"),
                URLQueryItem(name: "order_by", value: "new_download_count"),
                URLQueryItem(name: "order_direction", value: "desc"),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "tmdb_id", value: String(tmdbMovieID)),
                URLQueryItem(name: "type", value: "movie")
            ]
        )
        let response: OpenSubtitlesSearchResponseDTO = try await response(for: request)
        let page = response.toDomain()
        logSearchResults(page, tmdbMovieID: tmdbMovieID)
        return page
    }

    func downloadSubtitle(fileID: Int) async throws -> DownloadedSubtitle {
        guard fileID > 0 else {
            throw SubtitleServiceError.invalidRequest
        }

        log("Download requested for fileID \(fileID)")
        let request = try makeDownloadRequest(fileID: fileID)
        let response: OpenSubtitlesDownloadResponseDTO = try await response(for: request)

        guard response.link.scheme?.lowercased() == "https" else {
            log("Error: download response contains a non-HTTPS link")
            throw SubtitleServiceError.invalidResponse
        }

        let data = try await downloadFile(from: response.link)
        log("Downloaded \(response.fileName), fileID \(fileID), \(data.count) bytes")
        log(
            "Download quota: \(response.remainingDownloads) remaining, "
                + "reset at \(response.resetTimeUTC ?? "unknown")"
        )
        return DownloadedSubtitle(
            fileName: response.fileName,
            data: data,
            remainingDownloads: response.remainingDownloads,
            quotaResetDate: quotaResetDate(from: response.resetTimeUTC)
        )
    }

    // MARK: - Private

    private func logSearchResults(_ page: SubtitlePage, tmdbMovieID: Int) {
        log(
            "Found \(page.subtitles.count) English subtitle files for TMDB ID "
                + "\(tmdbMovieID), page \(page.currentPage)/\(page.totalPages)"
        )

        for (index, subtitle) in page.subtitles.enumerated() {
            log("[\(index + 1)] fileID=\(subtitle.fileID), file=\(subtitle.fileName)")
            log(
                "    release=\(subtitle.releaseName), files=\(subtitle.fileCount), "
                    + "downloads=\(subtitle.downloadCount), "
                    + "newDownloads=\(subtitle.newDownloadCount), rating=\(subtitle.rating)"
            )
            log(
                "    trusted=\(subtitle.fromTrustedSource), "
                    + "hearingImpaired=\(subtitle.hearingImpaired), "
                    + "foreignPartsOnly=\(subtitle.foreignPartsOnly), "
                    + "machine=\(subtitle.machineTranslated), ai=\(subtitle.aiTranslated)"
            )
        }
    }

    private func makeRequest(
        endpoint: Endpoint,
        queryItems: [URLQueryItem]
    ) throws -> URLRequest {
        guard !configuration.apiKey.isEmpty else {
            log("Error: missing API key")
            throw SubtitleServiceError.missingAPIKey
        }

        let endpointURL = configuration.baseURL.appending(path: endpoint.rawValue)
        guard var components = URLComponents(
            url: endpointURL,
            resolvingAgainstBaseURL: false
        ) else {
            log("Error: could not create URL components for \(endpoint.rawValue)")
            throw SubtitleServiceError.invalidRequest
        }

        components.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components.url else {
            log("Error: could not create URL for \(endpoint.rawValue)")
            throw SubtitleServiceError.invalidRequest
        }

        var request = URLRequest(url: url)
        addAPIHeaders(to: &request)
        return request
    }

    private func makeDownloadRequest(fileID: Int) throws -> URLRequest {
        var request = try makeRequest(endpoint: .download, queryItems: [])
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(
                OpenSubtitlesDownloadRequestDTO(fileID: fileID)
            )
        } catch {
            log("Error: could not encode the download request")
            throw SubtitleServiceError.invalidRequest
        }

        return request
    }

    private func addAPIHeaders(to request: inout URLRequest) {
        request.setValue(configuration.apiKey, forHTTPHeaderField: "Api-Key")
        request.setValue(configuration.userAgent, forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
    }

    private func response<Response: Decodable & Sendable>(
        for request: URLRequest
    ) async throws -> Response {
        let requestDescription = requestDescription(for: request)
        log("Request -> \(requestDescription)")

        let result: (Data, URLResponse)
        do {
            result = try await session.data(for: request)
        } catch {
            if !isCancellation(error) {
                log("Transport error for \(requestDescription): \(error.localizedDescription)")
            }
            throw error
        }

        let (data, response) = result

        guard let httpResponse = response as? HTTPURLResponse else {
            log("Error for \(requestDescription): response is not HTTP")
            throw SubtitleServiceError.invalidResponse
        }

        log("Response <- HTTP \(httpResponse.statusCode), \(data.count) bytes")
        try validateAPIResponse(httpResponse, data: data, requestDescription: requestDescription)

        do {
            return try JSONDecoder().decode(Response.self, from: data)
        } catch {
            log("Decoding error for \(requestDescription): \(String(reflecting: error))")
            throw SubtitleServiceError.invalidData
        }
    }

    private func validateAPIResponse(
        _ response: HTTPURLResponse,
        data: Data,
        requestDescription: String
    ) throws {
        switch response.statusCode {
        case 200..<300:
            return
        case 400, 422:
            logHTTPError(for: requestDescription, response: response, data: data)
            throw SubtitleServiceError.invalidRequest
        case 401:
            logHTTPError(for: requestDescription, response: response, data: data)
            throw SubtitleServiceError.unauthorized
        case 403:
            logHTTPError(for: requestDescription, response: response, data: data)
            throw SubtitleServiceError.accessDenied
        case 404:
            logHTTPError(for: requestDescription, response: response, data: data)
            throw SubtitleServiceError.unavailable
        case 406:
            logHTTPError(for: requestDescription, response: response, data: data)
            throw SubtitleServiceError.downloadLimitReached
        case 429:
            logHTTPError(for: requestDescription, response: response, data: data)
            throw SubtitleServiceError.rateLimited
        default:
            logHTTPError(for: requestDescription, response: response, data: data)
            throw SubtitleServiceError.server(statusCode: response.statusCode)
        }
    }

    private func downloadFile(from url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.setValue(configuration.userAgent, forHTTPHeaderField: "User-Agent")
        log("File request -> GET subtitle file")

        let result: (Data, URLResponse)
        do {
            result = try await session.data(for: request)
        } catch {
            if !isCancellation(error) {
                log("Subtitle file transport error: \(error.localizedDescription)")
            }
            throw error
        }

        let (data, response) = result

        guard let httpResponse = response as? HTTPURLResponse else {
            log("Subtitle file response is not HTTP")
            throw SubtitleServiceError.invalidResponse
        }

        log("File response <- HTTP \(httpResponse.statusCode), \(data.count) bytes")

        switch httpResponse.statusCode {
        case 200..<300 where !data.isEmpty:
            return data
        case 401, 403, 404:
            throw SubtitleServiceError.unavailable
        case 429:
            throw SubtitleServiceError.rateLimited
        case 200..<300:
            throw SubtitleServiceError.invalidData
        default:
            throw SubtitleServiceError.server(statusCode: httpResponse.statusCode)
        }
    }

    private func quotaResetDate(from value: String?) -> Date? {
        guard let value else {
            return nil
        }

        let fractionalSecondsFormatter = ISO8601DateFormatter()
        fractionalSecondsFormatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]

        if let date = fractionalSecondsFormatter.date(from: value) {
            return date
        }

        return ISO8601DateFormatter().date(from: value)
    }

    private func logHTTPError(
        for requestDescription: String,
        response: HTTPURLResponse,
        data: Data
    ) {
        let message = try? JSONDecoder().decode(ErrorResponse.self, from: data).message
        let details = message.map { ": \($0)" } ?? ""
        log("HTTP error for \(requestDescription): \(response.statusCode)\(details)")
    }

    private func requestDescription(for request: URLRequest) -> String {
        "\(request.httpMethod ?? "GET") \(request.url?.path ?? "unknown endpoint")"
    }

    private func isCancellation(_ error: Error) -> Bool {
        error is CancellationError || (error as? URLError)?.code == .cancelled
    }

    private func log(_ message: String) {
#if DEBUG
        print("[OpenSubtitles] \(message)")
#endif
    }
}
