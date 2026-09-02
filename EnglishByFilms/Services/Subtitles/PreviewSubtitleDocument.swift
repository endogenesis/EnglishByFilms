//
//  PreviewSubtitleDocument.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 29/08/2026.
//

import Foundation

enum PreviewSubtitleDocument {
    static let theMatrix = SubtitleDocument(
        fileName: "The.Matrix.1999.en.srt",
        sourceLanguage: Locale.Language(identifier: "en"),
        entries: [
            entry(1, from: 1_594.0, to: 1_597.2, "I imagine you're feeling a bit like Alice."),
            entry(2, from: 1_597.6, to: 1_599.4, "Tumbling down the rabbit hole?"),
            entry(3, from: 1_599.8, to: 1_601.2, "Hm. You could say that."),
            entry(4, from: 1_601.9, to: 1_604.0, "Do you believe in fate, Neo?"),
            entry(5, from: 1_604.6, to: 1_605.2, "No."),
            entry(6, from: 1_605.6, to: 1_606.4, "Why not?"),
            entry(7, from: 1_607.0, to: 1_608.8, "Because I don't like the idea…"),
            entry(8, from: 1_609.0, to: 1_611.0, "…that I'm not in control of my life."),
            entry(9, from: 1_613.5, to: 1_616.0, "I know exactly what you mean."),
            entry(10, from: 1_618.0, to: 1_621.0, "Let me tell you why you're here."),
            entry(11, from: 1_622.0, to: 1_626.0, "You're here because you know something."),
            entry(12, from: 1_626.5, to: 1_628.5, "But you feel it."),
            entry(13, from: 1_629.0, to: 1_632.5, "You've felt it your entire life."),
            entry(14, from: 1_633.0, to: 1_637.0, "There's something wrong with the world."),
            entry(15, from: 1_637.5, to: 1_640.0, "It's there, like a splinter in your mind."),
            entry(16, from: 1_641.0, to: 1_643.0, "Driving you mad."),
            entry(17, from: 1_644.0, to: 1_646.5, "This feeling has brought you to me."),
            entry(18, from: 1_647.5, to: 1_649.0, "Do you know what I'm talking about?"),
            entry(19, from: 1_650.0, to: 1_651.5, "The Matrix?"),
            entry(20, from: 1_652.5, to: 1_654.5, "Do you want to know what it is?")
        ]
    )

    private static func entry(
        _ id: Int,
        from startTime: TimeInterval,
        to endTime: TimeInterval,
        _ text: String
    ) -> SubtitleEntry {
        SubtitleEntry(id: id, startTime: startTime, endTime: endTime, text: text)
    }
}
