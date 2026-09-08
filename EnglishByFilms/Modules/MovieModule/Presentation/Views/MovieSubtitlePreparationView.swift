//
//  MovieSubtitlePreparationView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 08/09/2026.
//

import SwiftUI

struct MovieSubtitlePreparationView: View {
    let state: MovieSubtitlePreparationState

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top, spacing: 16) {
                MoviePreparationProgressView()
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text(description)
                        .font(.footnote)
                        .foregroundStyle(.textSecondary)
                }
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Rectangle()
                .fill(.glassBorder)
                .frame(height: 1)

            VStack(alignment: .leading, spacing: 10) {
                MoviePreparationStepView(
                    title: hasFoundSubtitle ? "Subtitles found" : "Finding English subtitles",
                    isComplete: hasFoundSubtitle,
                    isCurrent: state == .findingSubtitle
                )

                MoviePreparationStepView(
                    title: hasDownloadedSubtitle ? "Subtitles downloaded" : "Downloading subtitles",
                    isComplete: hasDownloadedSubtitle,
                    isCurrent: state == .downloadingSubtitle
                )

                MoviePreparationStepView(
                    title: "Creating your lesson",
                    isComplete: state == .subtitleReady,
                    isCurrent: state == .preparingSubtitle
                )
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.backgroundCard, in: .rect(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(.white.opacity(0.05), lineWidth: 1)
        }
    }

    private var title: String {
        switch state {
        case .findingSubtitle:
            "Finding subtitles"
        case .downloadingSubtitle:
            "Downloading subtitles"
        case .preparingSubtitle:
            "Creating your lesson"
        case .idle, .subtitleReady, .failed:
            "Preparing your lesson"
        }
    }

    private var description: String {
        if hasDownloadedSubtitle {
            "Subtitles downloaded. Turning movie dialogue into short exercises."
        } else {
            "We’ll download English subtitles, then create your lesson."
        }
    }

    private var hasFoundSubtitle: Bool {
        state == .downloadingSubtitle || hasDownloadedSubtitle
    }

    private var hasDownloadedSubtitle: Bool {
        state == .preparingSubtitle || state == .subtitleReady
    }
}

#Preview("Downloading") {
    MovieSubtitlePreparationView(state: .downloadingSubtitle)
        .padding(24)
        .background(.backgroundBase)
        .preferredColorScheme(.dark)
}
