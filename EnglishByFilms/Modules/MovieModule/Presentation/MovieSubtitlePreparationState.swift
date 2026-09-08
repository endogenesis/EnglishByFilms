//
//  MovieSubtitlePreparationState.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 21/08/2026.
//

enum MovieSubtitlePreparationState: Equatable {
    case idle
    case findingSubtitle
    case downloadingSubtitle
    case preparingSubtitle
    case subtitleReady
    case failed(message: String)

    var isPreparing: Bool {
        switch self {
        case .findingSubtitle, .downloadingSubtitle, .preparingSubtitle:
            true
        case .idle, .subtitleReady, .failed:
            false
        }
    }
}
