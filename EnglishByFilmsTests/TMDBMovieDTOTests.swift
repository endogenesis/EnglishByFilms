//
//  TMDBMovieDTOTests.swift
//  EnglishByFilmsTests
//
//  Created by Mikalai Tsyhankou on 26/08/2026.
//

import Foundation
import Testing
@testable import EnglishByFilms

struct TMDBMovieDTOTests {
    private let imageBaseURL = URL(string: "https://images.test/w342")!
    private let genreNamesByID = [28: "Action", 878: "Science Fiction"]

    @Test func decodesAndMapsPageFromTMDBJSON() throws {
        let json = """
        {
            "page": 2,
            "total_pages": 5,
            "results": [
                {
                    "id": 27205,
                    "title": "Inception",
                    "original_title": "Origine",
                    "overview": "A thief enters dreams.",
                    "release_date": "2010-07-15",
                    "poster_path": "/inception.jpg",
                    "vote_average": 8.4,
                    "genre_ids": [28, 878]
                }
            ]
        }
        """

        let dto = try JSONDecoder().decode(TMDBMoviePageDTO.self, from: Data(json.utf8))
        let page = dto.toDomain(imageBaseURL: imageBaseURL, genreNamesByID: genreNamesByID)

        #expect(page == MoviePage(
            movies: [
                MovieSummary(
                    id: 27205,
                    title: "Inception",
                    originalTitle: "Origine",
                    overview: "A thief enters dreams.",
                    releaseYear: 2010,
                    posterURL: URL(string: "https://images.test/w342/inception.jpg"),
                    rating: 8.4,
                    genres: ["Action", "Science Fiction"]
                )
            ],
            currentPage: 2,
            totalPages: 5
        ))
    }

    @Test func mapsMissingOptionalFieldsToNil() throws {
        let json = """
        {
            "id": 1,
            "title": "Untitled",
            "original_title": "Untitled",
            "overview": "",
            "vote_average": 0,
            "genre_ids": []
        }
        """

        let dto = try JSONDecoder().decode(TMDBMovieDTO.self, from: Data(json.utf8))
        let movie = dto.toDomain(imageBaseURL: imageBaseURL, genreNamesByID: genreNamesByID)

        #expect(movie.releaseYear == nil)
        #expect(movie.posterURL == nil)
    }

    @Test(arguments: [
        ("2010-07-15", 2010),
        ("1999", 1999),
        ("", nil),
        ("soon", nil)
    ] as [(String, Int?)])
    func parsesReleaseYearFromDatePrefix(releaseDate: String, expectedYear: Int?) {
        let movie = makeDTO(releaseDate: releaseDate)
            .toDomain(imageBaseURL: imageBaseURL, genreNamesByID: genreNamesByID)

        #expect(movie.releaseYear == expectedYear)
    }

    @Test(arguments: [
        ("/poster.jpg", "https://images.test/w342/poster.jpg"),
        ("poster.jpg", "https://images.test/w342/poster.jpg"),
        ("/nested/poster.jpg", "https://images.test/w342/nested/poster.jpg")
    ])
    func buildsPosterURLFromNormalizedPath(posterPath: String, expectedURL: String) {
        let movie = makeDTO(posterPath: posterPath)
            .toDomain(imageBaseURL: imageBaseURL, genreNamesByID: genreNamesByID)

        #expect(movie.posterURL == URL(string: expectedURL))
    }

    @Test func dropsUnknownGenreIDs() {
        let movie = makeDTO(genreIDs: [28, 999])
            .toDomain(imageBaseURL: imageBaseURL, genreNamesByID: genreNamesByID)

        #expect(movie.genres == ["Action"])
    }

    @Test func decodesGenreListIntoNamesByID() throws {
        let json = """
        {"genres": [{"id": 28, "name": "Action"}, {"id": 878, "name": "Science Fiction"}]}
        """

        let dto = try JSONDecoder().decode(TMDBGenreListDTO.self, from: Data(json.utf8))

        #expect(dto.namesByID == [28: "Action", 878: "Science Fiction"])
    }

    // MARK: - Private

    private func makeDTO(
        releaseDate: String? = nil,
        posterPath: String? = nil,
        genreIDs: [Int] = []
    ) -> TMDBMovieDTO {
        TMDBMovieDTO(
            id: 1,
            title: "Untitled",
            originalTitle: "Untitled",
            overview: "",
            releaseDate: releaseDate,
            posterPath: posterPath,
            voteAverage: 0,
            genreIDs: genreIDs
        )
    }
}
