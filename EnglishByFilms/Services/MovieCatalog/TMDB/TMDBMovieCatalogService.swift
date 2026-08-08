//
//  TMDBMovieCatalogService.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 08/08/2026.
//

import Foundation

struct TMDBMovieCatalogService: MovieCatalogService {
    private let configuration: TMDBConfiguration
    private let session: URLSession

    private enum Endpoint: String {
        case popularMovies = "movie/popular"
        case searchMovies = "search/movie"
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
        let response: TMDBMoviePageDTO = try await response(for: request)

        return response.toDomain(imageBaseURL: configuration.imageBaseURL)
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
        let response: TMDBMoviePageDTO = try await response(for: request)

        return response.toDomain(imageBaseURL: configuration.imageBaseURL)
    }

    // MARK: - Private

    private func makeRequest(endpoint: Endpoint, queryItems: [URLQueryItem]) throws -> URLRequest {
        guard !configuration.accessToken.isEmpty else {
            throw MovieCatalogError.missingAccessToken
        }

        let endpointURL = configuration.baseURL.appending(path: endpoint.rawValue)
        guard var components = URLComponents(
            url: endpointURL,
            resolvingAgainstBaseURL: false
        ) else {
            throw MovieCatalogError.invalidRequest
        }

        components.queryItems = queryItems + [
            URLQueryItem(name: "language", value: configuration.language)
        ]

        guard let url = components.url else {
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

    private func response<Response: Decodable>(for request: URLRequest) async throws -> Response {
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw MovieCatalogError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200..<300:
            break
        case 401:
            throw MovieCatalogError.unauthorized
        case 429:
            throw MovieCatalogError.rateLimited
        default:
            throw MovieCatalogError.server(statusCode: httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(Response.self, from: data)
        } catch {
            throw MovieCatalogError.invalidData
        }
    }
}
