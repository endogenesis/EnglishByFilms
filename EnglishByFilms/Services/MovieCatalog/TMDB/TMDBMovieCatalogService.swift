//
//  TMDBMovieCatalogService.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 08/08/2026.
//

import Foundation

actor TMDBMovieCatalogService: MovieCatalogService {
    private let configuration: TMDBConfiguration
    private let session: URLSession
    private var cachedGenreNamesByID: [Int: String]?

    private struct ErrorResponse: Decodable {
        let statusMessage: String?

        private enum CodingKeys: String, CodingKey {
            case statusMessage = "status_message"
        }
    }

    private enum Endpoint {
        case movieDetails(id: Int)
        case movieGenres
        case popularMovies
        case searchMovies

        var path: String {
            switch self {
            case let .movieDetails(id):
                "movie/\(id)"
            case .movieGenres:
                "genre/movie/list"
            case .popularMovies:
                "movie/popular"
            case .searchMovies:
                "search/movie"
            }
        }
    }

    init(configuration: TMDBConfiguration, session: URLSession = .shared) {
        self.configuration = configuration
        self.session = session
    }

    func popularMovies(page: Int) async throws -> MoviePage {
        let request = try makeRequest(
            endpoint: .popularMovies,
            queryItems: [
                URLQueryItem(name: "page", value: String(page))
            ]
        )
        async let response: TMDBMoviePageDTO = response(for: request)
        let genreNamesByID = try await genreNamesByID()

        return try await response.toDomain(
            imageBaseURL: configuration.posterImageBaseURL,
            genreNamesByID: genreNamesByID
        )
    }

    func searchMovies(query: String, page: Int) async throws -> MoviePage {
        let request = try makeRequest(
            endpoint: .searchMovies,
            queryItems: [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "include_adult", value: "false")
            ]
        )
        async let response: TMDBMoviePageDTO = response(for: request)
        let genreNamesByID = try await genreNamesByID()

        return try await response.toDomain(
            imageBaseURL: configuration.posterImageBaseURL,
            genreNamesByID: genreNamesByID
        )
    }

    func movieDetails(id: Int) async throws -> MovieDetails {
        let request = try makeRequest(endpoint: .movieDetails(id: id), queryItems: [])
        let response: TMDBMovieDetailsDTO = try await response(for: request)

        return response.toDomain(
            backdropImageBaseURL: configuration.backdropImageBaseURL
        )
    }

    // MARK: - Private

    private func genreNamesByID() async throws -> [Int: String] {
        if let cachedGenreNamesByID {
            return cachedGenreNamesByID
        }

        let request = try makeRequest(endpoint: .movieGenres, queryItems: [])
        let response: TMDBGenreListDTO = try await response(for: request)
        let genreNamesByID = response.namesByID
        cachedGenreNamesByID = genreNamesByID

        return genreNamesByID
    }

    private func makeRequest(endpoint: Endpoint, queryItems: [URLQueryItem]) throws -> URLRequest {
        guard !configuration.accessToken.isEmpty else {
            log("Error: missing access token")
            throw MovieCatalogError.missingAccessToken
        }

        let endpointURL = configuration.baseURL.appending(path: endpoint.path)
        guard var components = URLComponents(
            url: endpointURL,
            resolvingAgainstBaseURL: false
        ) else {
            log("Error: could not create URL components for \(endpoint.path)")
            throw MovieCatalogError.invalidRequest
        }

        components.queryItems = queryItems + [
            URLQueryItem(name: "language", value: configuration.language)
        ]

        guard let url = components.url else {
            log("Error: could not create URL for \(endpoint.path)")
            throw MovieCatalogError.invalidRequest
        }

        var request = URLRequest(url: url)
        request.setValue(
            "Bearer \(configuration.accessToken)",
            forHTTPHeaderField: "Authorization"
        )
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return request
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
            throw MovieCatalogError.invalidResponse
        }

        log("Response <- HTTP \(httpResponse.statusCode), \(data.count) bytes")

        switch httpResponse.statusCode {
        case 200..<300:
            break
        case 401:
            logHTTPError(for: requestDescription, response: httpResponse, data: data)
            throw MovieCatalogError.unauthorized
        case 429:
            logHTTPError(for: requestDescription, response: httpResponse, data: data)
            throw MovieCatalogError.rateLimited
        default:
            logHTTPError(for: requestDescription, response: httpResponse, data: data)
            throw MovieCatalogError.server(statusCode: httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(Response.self, from: data)
        } catch {
            log("Decoding error for \(requestDescription): \(String(reflecting: error))")
            throw MovieCatalogError.invalidData
        }
    }

    private func logHTTPError(
        for requestDescription: String,
        response: HTTPURLResponse,
        data: Data
    ) {
        let message = try? JSONDecoder().decode(ErrorResponse.self, from: data).statusMessage
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
        print("[TMDB] \(message)")
#endif
    }
}
