//
//  LessonChoiceButton.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 18/09/2026.
//

import Foundation
import SwiftUI

struct LessonChoiceButton: View {
    let title: String
    let correctAnswer: String
    let selectedAnswer: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.headline)

                Spacer()

                if let symbolName {
                    Image(systemName: symbolName)
                }
            }
            .foregroundStyle(foregroundStyle)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background {
                RoundedRectangle(cornerRadius: 18)
                    .fill(backgroundStyle)
                    .stroke(borderStyle, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .disabled(selectedAnswer != nil)
    }

    private var isCorrectChoice: Bool {
        answersMatch(title, correctAnswer)
    }

    private var isSelectedChoice: Bool {
        guard let selectedAnswer else {
            return false
        }

        return answersMatch(title, selectedAnswer)
    }

    private var symbolName: String? {
        guard selectedAnswer != nil else {
            return nil
        }

        if isCorrectChoice {
            return "checkmark.circle.fill"
        }

        return isSelectedChoice ? "xmark.circle.fill" : nil
    }

    private var foregroundStyle: Color {
        if selectedAnswer != nil, isCorrectChoice {
            return .green
        }

        if selectedAnswer != nil, isSelectedChoice {
            return .semanticError
        }

        return .white
    }

    private var backgroundStyle: Color {
        if selectedAnswer != nil, isCorrectChoice {
            return .green.opacity(0.12)
        }

        if selectedAnswer != nil, isSelectedChoice {
            return .semanticError.opacity(0.12)
        }

        return .backgroundCard
    }

    private var borderStyle: Color {
        if selectedAnswer != nil, isCorrectChoice {
            return .green.opacity(0.7)
        }

        if selectedAnswer != nil, isSelectedChoice {
            return .semanticError.opacity(0.7)
        }

        return .glassBorder
    }

    private func answersMatch(_ lhs: String, _ rhs: String) -> Bool {
        lhs.compare(rhs, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
    }
}
