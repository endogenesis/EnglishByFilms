//
//  TMDBMovieCatalogServiceTests.swift
//  EnglishByFilmsTests
//
//  Created by Mikalai Tsyhankou on 26/08/2026.
//

import Foundation
import Testing
@testable import EnglishByFilms

struct TMDBMovieCatalogServiceTests {
    private let host = "tmdb-\(UUID().uuidString.lowercased()).test"

    // MARK: - Requests

    @Test func sendsAuthorizedMovieDetailsRequest() async throws {
        stubEndpoints()

        _ = try await makeService().movieDetails(id: 27205)

        let request = try #require(URLProtocolStub.recordedRequests(forHost: host).first)
        #expect(request.path == "/3/movie/27205")
        #expect(request.headers["Authorization"] == "Bearer test-token")
        #expect(request.headers["Accept"] == "application/json")
        #expect(request.queryValue(for: "language") == "en-US")
    }

    @Test func searchMoviesSendsQueryParameters() async throws {
        stubEndpoints()

        _ = try await makeService().searchMovies(query: "dune part two", page: 3)

        let request = try #require(
            URLProtocolStub.recordedRequests(forHost: host)
                .first { $0.path.hasSuffix("/search/movie") }
        )
        #expect(request.queryValue(for: "query") == "dune part two")
        #expect(request.queryValue(for: "page") == "3")
        #expect(request.queryValue(for: "include_adult") == "false")
        #expect(request.queryValue(for: "language") == "en-US")
    }

    @Test func throwsWhenAccessTokenIsMissing() async {
        let service = makeService(accessToken: "")

        await expectThrows(MovieCatalogError.missingAccessToken) {
            try await service.movieDetails(id: 1)
        }
        #expect(URLProtocolStub.recordedRequests(forHost: host).isEmpty)
    }

    // MARK: - Responses

    @Test func mapsMovieDetailsResponseToDomain() async throws {
        stubEndpoints()

        let details = try await makeService().movieDetails(id: 27205)

        #expect(details == MovieDetails(
            id: 27205,
            title: "Inception",
            overview: "A thief enters dreams.",
            releaseYear: 2010,
            runtimeMinutes: 148,
            backdropURL: URL(string: "https://images.test/w780/backdrop.jpg"),
            rating: 8.4,
            genres: ["Action"]
        ))
    }

    @Test func popularMoviesFetchesGenresAndMapsNames() async throws {
        stubEndpoints()

        let page = try await makeService().popularMovies(page: 1)

        #expect(page.currentPage == 1)
        #expect(page.totalPages == 2)
        #expect(page.movies.map(\.id) == [27205])
        #expect(page.movies.first?.genres == ["Action", "Science Fiction"])

        let popularRequest = try #require(
            URLProtocolStub.recordedRequests(forHost: host)
                .first { $0.path.hasSuffix("/movie/popular") }
        )
        #expect(popularRequest.queryValue(for: "page") == "1")
    }

    @Test func cachesGenresBetweenRequests() async throws {
        stubEndpoints()
        let service = makeService()

        _ = try await service.popularMovies(page: 1)
        _ = try await service.popularMovies(page: 2)

        let requests = URLProtocolStub.recordedRequests(forHost: host)
        let genreRequests = requests.filter { $0.path.hasSuffix("/genre/movie/list") }
        let popularRequests = requests.filter { $0.path.hasSuffix("/movie/popular") }
        #expect(genreRequests.count == 1)
        #expect(popularRequests.count == 2)
    }

    // MARK: - Errors

    @Test(arguments: [
        (401, MovieCatalogError.unauthorized),
        (429, MovieCatalogError.rateLimited),
        (500, MovieCatalogError.server(statusCode: 500)),
        (503, MovieCatalogError.server(statusCode: 503))
    ])
    func mapsHTTPErrorStatusToDomainError(statusCode: Int, expected: MovieCatalogError) async {
        stubEndpoints(statusCode: statusCode)

        await expectThrows(expected) {
            try await makeService().movieDetails(id: 1)
        }
    }

    @Test func throwsInvalidDataForMalformedJSON() async {
        URLProtocolStub.setHandler(forHost: host) { _ in
            (200, Data("not json".utf8))
        }

        await expectThrows(MovieCatalogError.invalidData) {
            try await makeService().movieDetails(id: 1)
        }
    }

    @Test func propagatesTransportErrors() async {
        URLProtocolStub.setHandler(forHost: host) { _ in
            throw URLError(.notConnectedToInternet)
        }

        do {
            _ = try await makeService().movieDetails(id: 1)
            Issue.record("Expected a transport error to be thrown")
        } catch let error as URLError {
            #expect(error.code == .notConnectedToInternet)
        } catch {
            Issue.record("Expected URLError, got \(error)")
        }
    }

    // MARK: - Private

    private func makeService(accessToken: String = "test-token") -> TMDBMovieCatalogService {
        let configuration = TMDBConfiguration(
            baseURL: URL(string: "https://\(host)/3")!,
            posterImageBaseURL: URL(string: "https://images.test/w342")!,
            backdropImageBaseURL: URL(string: "https://images.test/w780")!,
            accessToken: accessToken,
            language: "en-US"
        )

        return TMDBMovieCatalogService(
            configuration: configuration,
            session: URLProtocolStub.makeSession()
        )
    }

    private func stubEndpoints(statusCode: Int = 200) {
        let genresJSON = """
        {"genres": [{"id": 28, "name": "Action"}, {"id": 878, "name": "Science Fiction"}]}
        """
        let moviePageJSON = """
        {
            "page": 1,
            "total_pages": 2,
            "results": [
                {
                    "id": 27205,
                    "title": "Inception",
                    "original_title": "Inception",
                    "overview": "A thief enters dreams.",
                    "release_date": "2010-07-15",
                    "poster_path": "/inception.jpg",
                    "vote_average": 8.4,
                    "genre_ids": [28, 878]
                }
            ]
        }
        """
        let movieDetailsJSON = """
        {
            "id": 27205,
            "title": "Inception",
            "overview": "A thief enters dreams.",
            "release_date": "2010-07-15",
            "runtime": 148,
            "backdrop_path": "/backdrop.jpg",
            "vote_average": 8.4,
            "genres": [{"id": 28, "name": "Action"}]
        }
        """

        URLProtocolStub.setHandler(forHost: host) { request in
            if request.path.hasSuffix("/genre/movie/list") {
                return (200, Data(genresJSON.utf8))
            }

            if request.path.hasSuffix("/movie/popular") || request.path.hasSuffix("/search/movie") {
                return (statusCode, Data(moviePageJSON.utf8))
            }

            return (statusCode, Data(movieDetailsJSON.utf8))
        }
    }
}
