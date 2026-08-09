//
//  SearchViewState.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 06/08/2026.
//

enum SearchViewState: Equatable {
    case idle
    case loading
    case loaded(movies: [MovieSummary], nextPage: SearchNextPageState)
    case empty(query: String)
    case failed(message: String)
}

enum SearchNextPageState: Equatable {
    case ready
    case loading
    case failed(message: String)
    case finished
}
