//
//  PreviewSubtitleScript.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 27/08/2026.
//

import Foundation

enum PreviewSubtitleScript {
    static let theMatrix: [SubtitleCue] = [
        cue(1, from: 1_594.0, to: 1_597.2, "I imagine you're feeling a bit like Alice."),
        cue(2, from: 1_597.6, to: 1_599.4, "Tumbling down the rabbit hole?"),
        cue(3, from: 1_599.8, to: 1_601.2, "Hm. You could say that."),
        cue(4, from: 1_601.9, to: 1_604.0, "Do you believe in fate, Neo?"),
        cue(5, from: 1_604.6, to: 1_605.2, "No."),
        cue(6, from: 1_605.6, to: 1_606.4, "Why not?"),
        cue(7, from: 1_607.0, to: 1_608.8, "Because I don't like the idea…"),
        cue(8, from: 1_609.0, to: 1_611.0, "…that I'm not in control of my life."),
        cue(9, from: 1_613.5, to: 1_616.0, "I know exactly what you mean."),
        cue(10, from: 1_618.0, to: 1_621.0, "Let me tell you why you're here."),
        cue(11, from: 1_622.0, to: 1_626.0, "You're here because you know something. What you know you can't explain."),
        cue(12, from: 1_626.5, to: 1_628.5, "But you feel it."),
        cue(13, from: 1_629.0, to: 1_632.5, "You've felt it your entire life."),
        cue(14, from: 1_633.0, to: 1_637.0, "That there's something wrong with the world. You don't know what it is."),
        cue(15, from: 1_637.5, to: 1_640.0, "But it's there, like a splinter in your mind."),
        cue(16, from: 1_641.0, to: 1_643.0, "Driving you mad."),
        cue(17, from: 1_644.0, to: 1_646.5, "It is this feeling that has brought you to me."),
        cue(18, from: 1_647.5, to: 1_649.0, "Do you know what I'm talking about?"),
        cue(19, from: 1_650.0, to: 1_651.5, "The Matrix?"),
        cue(20, from: 1_652.5, to: 1_654.5, "Do you want to know what it is?")
    ]

    private static func cue(_ id: Int, from start: Double, to end: Double, _ text: String) -> SubtitleCue {
        SubtitleCue(
            id: id,
            startTime: .seconds(start),
            endTime: .seconds(end),
            text: text
        )
    }
}
