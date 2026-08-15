//
//  SRTSubtitleParser.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 15/08/2026.
//

import Foundation

nonisolated struct SRTSubtitleParser {
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

        let text = block.dropFirst(timelineIndex + 1)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")

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
        let components = value.replacing(",", with: ".").split(separator: ":")

        guard
            components.count == 3,
            let hours = Double(components[0]),
            let minutes = Double(components[1]),
            let seconds = Double(components[2]),
            hours >= 0,
            minutes >= 0 && minutes < 60,
            seconds >= 0 && seconds < 60
        else {
            return nil
        }

        return hours * 3_600 + minutes * 60 + seconds
    }
}
