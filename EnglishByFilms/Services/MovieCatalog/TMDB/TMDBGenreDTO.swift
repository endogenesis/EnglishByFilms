//
//  TMDBGenreDTO.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 10/08/2026.
//

nonisolated struct TMDBGenreListDTO: Decodable {
    let genres: [TMDBGenreDTO]

    var namesByID: [Int: String] {
        Dictionary(uniqueKeysWithValues: genres.map { ($0.id, $0.name) })
    }
}

nonisolated struct TMDBGenreDTO: Decodable {
    let id: Int
    let name: String
}
