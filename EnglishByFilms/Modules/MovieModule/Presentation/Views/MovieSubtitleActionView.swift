//
//  MovieSubtitleActionView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 21/08/2026.
//

import SwiftUI

struct MovieSubtitleActionView: View {
    let state: MovieSubtitlePreparationState
    let action: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            if let errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.semanticError)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            PrimaryButton(title, action: action)
                .disabled(!isButtonEnabled)
                .overlay(alignment: .leading) {
                    if isLoading {
                        ProgressView()
                            .tint(.backgroundBase)
                            .padding(.leading, 24)
                            .accessibilityHidden(true)
                    }
                }
        }
    }

    private var title: String {
        switch state {
        case .idle:
            "Open subtitles"
        case .findingSubtitle:
            "Finding subtitles…"
        case .downloadingSubtitle:
            "Downloading subtitles…"
        case .subtitleReady:
            "Open subtitles"
        case .failed:
            "Try again"
        }
    }

    private var isButtonEnabled: Bool {
        switch state {
        case .idle, .subtitleReady, .failed:
            true
        case .findingSubtitle, .downloadingSubtitle:
            false
        }
    }

    private var isLoading: Bool {
        switch state {
        case .findingSubtitle, .downloadingSubtitle:
            true
        case .idle, .subtitleReady, .failed:
            false
        }
    }

    private var errorMessage: String? {
        if case let .failed(message) = state {
            message
        } else {
            nil
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        MovieSubtitleActionView(state: .idle, action: { })
        MovieSubtitleActionView(state: .findingSubtitle, action: { })
        MovieSubtitleActionView(
            state: .failed(message: "No supported English subtitles were found."),
            action: { }
        )
    }
    .padding(24)
    .background(.backgroundBase)
    .preferredColorScheme(.dark)
}
