//
//  SubtitleDocument.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 15/08/2026.
//

import Foundation

nonisolated struct SubtitleDocument: Equatable {
    let fileName: String
    let sourceLanguage: Locale.Language
    let entries: [SubtitleEntry]
}
