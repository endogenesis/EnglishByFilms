//
//  MovieLessonActionView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 21/08/2026.
//

import SwiftUI

struct MovieLessonActionView: View {
    let state: MovieLessonPreparationState
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
            "Start learning"
        case .findingSubtitle:
            "Finding subtitles…"
        case .downloadingSubtitle:
            "Downloading subtitles…"
        case .subtitleReady:
            "Subtitles downloaded"
        case .failed:
            "Try again"
        }
    }

    private var isButtonEnabled: Bool {
        switch state {
        case .idle, .failed:
            true
        case .findingSubtitle, .downloadingSubtitle, .subtitleReady:
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
        MovieLessonActionView(state: .idle, action: { })
        MovieLessonActionView(state: .findingSubtitle, action: { })
        MovieLessonActionView(
            state: .failed(message: "No supported English subtitles were found."),
            action: { }
        )
    }
    .padding(24)
    .background(.backgroundBase)
    .preferredColorScheme(.dark)
}
