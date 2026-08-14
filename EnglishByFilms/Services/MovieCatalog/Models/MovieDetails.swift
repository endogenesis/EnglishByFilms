//
//  MovieDetails.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 14/08/2026.
//

import Foundation

struct MovieDetails: Identifiable, Equatable {
    let id: Int
    let title: String
    let overview: String
    let releaseYear: Int?
    let runtimeMinutes: Int?
    let backdropURL: URL?
    let rating: Double
    let genres: [String]
}
