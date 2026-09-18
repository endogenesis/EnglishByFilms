//
//  SRTSubtitleParser.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 15/08/2026.
//

import Foundation

nonisolated struct SRTSubtitleParser {
    // SRT supports a small HTML-derived subset; unknown markup stays untouched.
    private static let formattingTagPattern =
        #"(?i)</?(?:i|b|u)\s*>|</?font(?:\s+color\s*=\s*(?:"[^"]*"|'[^']*'|[^\s>]+))?\s*>"#

    func parse(
        _ subtitle: DownloadedSubtitle,
        sourceLanguage: Locale.Language
    ) throws -> SubtitleDocument {
        guard var source = String(data: subtitle.data, encoding: .utf8) else {
            throw SRTSubtitleParserError.invalidTextEncoding
        }

        if source.first == "\u{feff}" {
            source.removeFirst()
        }

        let normalizedSource = source
            .replacing("\r\n", with: "\n")
            .replacing("\r", with: "\n")

        var entries: [SubtitleEntry] = []

        for block in blocks(from: normalizedSource) {
            guard let entry = parseEntry(from: block, id: entries.count + 1) else {
                continue
            }

            entries.append(entry)
        }

        guard !entries.isEmpty else {
            throw SRTSubtitleParserError.noValidEntries
        }

        return SubtitleDocument(
            fileName: subtitle.fileName,
            sourceLanguage: sourceLanguage,
            entries: entries
        )
    }

    // MARK: - Private

    private func blocks(from source: String) -> [[Substring]] {
        var blocks: [[Substring]] = []
        var currentBlock: [Substring] = []

        for line in source.split(separator: "\n", omittingEmptySubsequences: false) {
            if line.trimmingCharacters(in: .whitespaces).isEmpty {
                if !currentBlock.isEmpty {
                    blocks.append(currentBlock)
                    currentBlock.removeAll(keepingCapacity: true)
                }
            } else {
                currentBlock.append(line)
            }
        }

        if !currentBlock.isEmpty {
            blocks.append(currentBlock)
        }

        return blocks
    }

    private func parseEntry(from block: [Substring], id: Int) -> SubtitleEntry? {
        guard let timelineIndex = block.firstIndex(where: { $0.contains("-->") }) else {
            return nil
        }

        let timeline = String(block[timelineIndex])

        guard let separatorRange = timeline.range(of: "-->") else {
            return nil
        }

        let startText = timeline[..<separatorRange.lowerBound]
            .trimmingCharacters(in: .whitespaces)
        let endText = timeline[separatorRange.upperBound...]
            .trimmingCharacters(in: .whitespaces)

        guard
            let startTime = parseTimestamp(startText),
            let endTime = parseTimestamp(endText),
            startTime <= endTime
        else {
            return nil
        }

        let sourceText = block.dropFirst(timelineIndex + 1)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        let text = sourceText.replacingOccurrences(
            of: Self.formattingTagPattern,
            with: "",
            options: .regularExpression
        )

        guard !text.isEmpty else {
            return nil
        }

        return SubtitleEntry(
            id: id,
            startTime: startTime,
            endTime: endTime,
            text: text
        )
    }

    private func parseTimestamp(_ value: String) -> TimeInterval? {
        let timeComponents = value.split(separator: ":", omittingEmptySubsequences: false)

        guard
            timeComponents.count == 3,
            let hours = parseDecimalInteger(timeComponents[0], digitCount: 2...19),
            let minutes = parseDecimalInteger(timeComponents[1], digitCount: 2...2),
            minutes < 60
        else {
            return nil
        }

        let secondComponents = timeComponents[2].split(
            omittingEmptySubsequences: false,
            whereSeparator: { $0 == "," || $0 == "." }
        )

        guard
            secondComponents.count == 2,
            let seconds = parseDecimalInteger(secondComponents[0], digitCount: 2...2),
            seconds < 60,
            let milliseconds = parseDecimalInteger(secondComponents[1], digitCount: 3...3)
        else {
            return nil
        }

        let (hourMilliseconds, hourOverflow) = hours.multipliedReportingOverflow(by: 3_600_000)
        let minuteMilliseconds = minutes * 60_000
        let secondMilliseconds = seconds * 1_000
        let (hoursAndMinutes, minuteOverflow) = hourMilliseconds.addingReportingOverflow(
            minuteMilliseconds
        )
        let (wholeSeconds, secondOverflow) = hoursAndMinutes.addingReportingOverflow(
            secondMilliseconds
        )
        let (totalMilliseconds, millisecondOverflow) = wholeSeconds.addingReportingOverflow(
            milliseconds
        )

        guard !hourOverflow, !minuteOverflow, !secondOverflow, !millisecondOverflow else {
            return nil
        }

        let timestamp = TimeInterval(totalMilliseconds) / 1_000
        guard timestamp.isFinite, timestamp >= 0 else {
            return nil
        }

        return timestamp
    }

    private func parseDecimalInteger(
        _ component: Substring,
        digitCount: ClosedRange<Int>
    ) -> Int64? {
        let bytes = component.utf8

        guard
            digitCount.contains(bytes.count),
            bytes.allSatisfy({ $0 >= 48 && $0 <= 57 })
        else {
            return nil
        }

        return Int64(component)
    }
}
