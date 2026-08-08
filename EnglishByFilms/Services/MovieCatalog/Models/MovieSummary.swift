//
//  MovieSummary.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 08/08/2026.
//

import Foundation

struct MovieSummary: Identifiable, Equatable {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let releaseYear: Int?
    let posterURL: URL?
    let rating: Double
}
