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
}
