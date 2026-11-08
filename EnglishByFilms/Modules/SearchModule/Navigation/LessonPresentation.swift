//
//  LessonPresentation.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 20/09/2026.
//

import Foundation

struct LessonPresentation: Identifiable {
    let id = UUID()
    let movieTitle: String
    let lesson: LessonContent
}
