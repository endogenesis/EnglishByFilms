//
//  SubtitleCue.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 27/08/2026.
//

import Foundation

struct SubtitleCue: Identifiable, Equatable, Sendable {
    let id: Int
    let startTime: Duration
    let endTime: Duration
    let text: String
}
