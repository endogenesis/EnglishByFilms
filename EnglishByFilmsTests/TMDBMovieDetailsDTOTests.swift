//
//  TMDBMovieDetailsDTOTests.swift
//  EnglishByFilmsTests
//
//  Created by Mikalai Tsyhankou on 26/08/2026.
//

import Foundation
import Testing
@testable import EnglishByFilms

struct TMDBMovieDetailsDTOTests {
    private let backdropBaseURL = URL(string: "https://images.test/w780")!

    @Test func decodesAndMapsDetailsFromTMDBJSON() throws {
        let json = """
        {
            "id": 27205,
            "title": "Inception",
            "overview": "A thief enters dreams.",
            "release_date": "2010-07-15",
            "runtime": 148,
            "backdrop_path": "/backdrop.jpg",
            "vote_average": 8.4,
            "genres": [
                {"id": 28, "name": "Action"},
                {"id": 878, "name": "Science Fiction"}
            ]
        }
        """

        let dto = try JSONDecoder().decode(TMDBMovieDetailsDTO.self, from: Data(json.utf8))
        let details = dto.toDomain(backdropImageBaseURL: backdropBaseURL)

        #expect(details == MovieDetails(
            id: 27205,
            title: "Inception",
            overview: "A thief enters dreams.",
            releaseYear: 2010,
            runtimeMinutes: 148,
            backdropURL: URL(string: "https://images.test/w780/backdrop.jpg"),
            rating: 8.4,
            genres: ["Action", "Science Fiction"]
        ))
    }

    @Test func mapsMissingOptionalFieldsToNil() throws {
        let json = """
        {
            "id": 1,
            "title": "Untitled",
            "overview": "",
            "vote_average": 0,
            "genres": []
        }
        """

        let dto = try JSONDecoder().decode(TMDBMovieDetailsDTO.self, from: Data(json.utf8))
        let details = dto.toDomain(backdropImageBaseURL: backdropBaseURL)

        #expect(details.releaseYear == nil)
        #expect(details.runtimeMinutes == nil)
        #expect(details.backdropURL == nil)
    }

    @Test func ignoresInvalidReleaseDate() {
        let dto = TMDBMovieDetailsDTO(
            id: 1,
            title: "Untitled",
            overview: "",
            releaseDate: "soon",
            runtime: nil,
            backdropPath: nil,
            voteAverage: 0,
            genres: []
        )

        #expect(dto.toDomain(backdropImageBaseURL: backdropBaseURL).releaseYear == nil)
    }
}
