//
//  MovieViewState.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 14/08/2026.
//

enum MovieViewState: Equatable {
    case loading
    case loaded(MovieDetails)
    case failed(message: String)
}
