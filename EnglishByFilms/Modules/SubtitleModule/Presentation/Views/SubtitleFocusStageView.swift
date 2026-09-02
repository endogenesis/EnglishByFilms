//
//  SubtitleFocusStageView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 29/08/2026.
//

import SwiftUI

struct SubtitleFocusStageView: View {
    let entries: [SubtitleEntry]
    let activeIndex: Int
    let selectEntry: (Int) -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var centeredIndex: Int?

    init(entries: [SubtitleEntry], activeIndex: Int, selectEntry: @escaping (Int) -> Void) {
        self.entries = entries
        self.activeIndex = activeIndex
        self.selectEntry = selectEntry
        _centeredIndex = State(initialValue: activeIndex)
    }

    var body: some View {
        Group {
            if entries.isEmpty {
                ContentUnavailableView(
                    "No subtitles",
                    systemImage: "captions.bubble",
                    description: Text("This subtitle file does not contain any lines.")
                )
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        Color.clear
                            .containerRelativeFrame(.vertical) { length, _ in
                                length / 2
                            }
                            .accessibilityHidden(true)

                        LazyVStack(spacing: 20) {
                            ForEach(entries.indices, id: \.self) { index in
                                let entry = entries[index]
                                let distance = index - activeIndex

                                if distance == 0 {
                                    VStack(spacing: 14) {
                                        SubtitleTimeBadgeView(time: entry.startTime)
                                        SubtitleLineView(text: entry.text, distance: distance)
                                    }
                                    .accessibilityElement(children: .combine)
                                } else {
                                    SubtitleLineView(text: entry.text, distance: distance)
                                }
                            }
                        }
                        .scrollTargetLayout()

                        Color.clear
                            .containerRelativeFrame(.vertical) { length, _ in
                                length / 2
                            }
                            .accessibilityHidden(true)
                    }
                }
                .scrollIndicators(.hidden)
                .scrollPosition(id: $centeredIndex, anchor: .center)
                .scrollTargetBehavior(.viewAligned(anchor: .center))
                .onChange(of: centeredIndex, selectCenteredEntry)
                .onChange(of: activeIndex, centerActiveEntry)
            }
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func selectCenteredEntry(_ oldIndex: Int?, _ newIndex: Int?) {
        guard let newIndex, newIndex != oldIndex else {
            return
        }

        selectEntry(newIndex)
    }

    private func centerActiveEntry(_ oldIndex: Int, _ newIndex: Int) {
        guard newIndex != oldIndex, centeredIndex != newIndex else {
            return
        }

        if reduceMotion {
            centeredIndex = newIndex
        } else {
            withAnimation(.snappy(duration: 0.35)) {
                centeredIndex = newIndex
            }
        }
    }
}

#Preview {
    @Previewable @State var activeIndex = 3

    SubtitleFocusStageView(
        entries: PreviewSubtitleDocument.theMatrix.entries,
        activeIndex: activeIndex,
        selectEntry: { activeIndex = $0 }
    )
    .background(.backgroundBase)
    .preferredColorScheme(.dark)
}
