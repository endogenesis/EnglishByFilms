//
//  SRTSubtitleParserError.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 15/08/2026.
//

import Foundation

nonisolated enum SRTSubtitleParserError: LocalizedError {
    case invalidTextEncoding
    case noValidEntries

    var errorDescription: String? {
        switch self {
        case .invalidTextEncoding:
            "The subtitle file is not valid UTF-8 text."
        case .noValidEntries:
            "The subtitle file does not contain valid SRT entries."
        }
    }
}
