//
//  MoviePage.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 08/08/2026.
//

struct MoviePage: Equatable {
    let movies: [MovieSummary]
    let currentPage: Int
    let totalPages: Int
}
