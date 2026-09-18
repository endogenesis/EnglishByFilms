//
//  SRTSubtitleParserTests.swift
//  EnglishByFilmsTests
//
//  Created by Mikalai Tsyhankou on 18/09/2026.
//

import Foundation
import Testing
@testable import EnglishByFilms

struct SRTSubtitleParserTests {
    private let parser = SRTSubtitleParser()

    @Test func removesSupportedFormattingTags() throws {
        let source = """
        1
        00:00:01,000 --> 00:00:02,000
        <i>Come</i> <b>with</b> <u>me.</u>

        2
        00:00:03,000 --> 00:00:04,000
        <font color="#00FF00">Wake up, Neo.</font>
        """

        let document = try parser.parse(
            .fixture(data: Data(source.utf8)),
            sourceLanguage: Locale.Language(identifier: "en")
        )

        #expect(document.entries.map(\.text) == ["Come with me.", "Wake up, Neo."])
    }

    @Test func preservesPlainMultilineDialogueAndUnknownMarkup() throws {
        let source = """
        1
        00:00:01,000 --> 00:00:02,000
        Two is < three
        and five is > four.

        2
        00:00:03,000 --> 00:00:04,000
        <speaker>Neo</speaker>
        """

        let document = try parser.parse(
            .fixture(data: Data(source.utf8)),
            sourceLanguage: Locale.Language(identifier: "en")
        )

        #expect(document.entries.map(\.text) == [
            "Two is < three and five is > four.",
            "<speaker>Neo</speaker>"
        ])
    }

    @Test func skipsInfiniteTimestamp() throws {
        let source = """
        1
        inf:00:00,000 --> inf:00:01,000
        Unsafe dialogue

        2
        00:00:01,000 --> 00:00:02,000
        Safe dialogue
        """

        let document = try parse(source)

        #expect(document.entries.map(\.text) == ["Safe dialogue"])
    }

    @Test func skipsTimestampWhenMillisecondArithmeticOverflows() throws {
        let source = """
        1
        9223372036854775807:00:00,000 --> 9223372036854775807:00:01,000
        Unsafe dialogue

        2
        00:00:01,000 --> 00:00:02,000
        Safe dialogue
        """

        let document = try parse(source)

        #expect(document.entries.map(\.text) == ["Safe dialogue"])
    }

    @Test func skipsTimestampsWithInvalidGrammarOrComponentRanges() throws {
        let source = """
        1
        0:00:00,000 --> 00:00:01,000
        Invalid hour width

        2
        00:60:00,000 --> 00:60:01,000
        Invalid minutes

        3
        00:00:60,000 --> 00:00:61,000
        Invalid seconds

        4
        00:00:01,1000 --> 00:00:02,1000
        Invalid milliseconds

        5
        00:00:01,000 --> 00:00:02,000
        Safe dialogue
        """

        let document = try parse(source)

        #expect(document.entries.map(\.text) == ["Safe dialogue"])
    }

    @Test func parsesValidTimestampComponents() throws {
        let source = """
        1
        12:34:56,789 --> 12:34:57.001
        Valid dialogue
        """

        let document = try parse(source)
        let entry = try #require(document.entries.first)

        #expect(entry.startTime.isFinite)
        #expect(entry.endTime.isFinite)
        #expect(abs(entry.startTime - 45_296.789) < 0.000_001)
        #expect(abs(entry.endTime - 45_297.001) < 0.000_001)
    }

    private func parse(_ source: String) throws -> SubtitleDocument {
        try parser.parse(
            .fixture(data: Data(source.utf8)),
            sourceLanguage: Locale.Language(identifier: "en")
        )
    }
}
