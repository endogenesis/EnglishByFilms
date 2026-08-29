//
//  MovieLessonPreparationState.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 21/08/2026.
//

enum MovieLessonPreparationState: Equatable {
    case idle
    case findingSubtitle
    case downloadingSubtitle
    case subtitleReady
    case failed(message: String)
}
