//
//  MoviePreparationStepView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 08/09/2026.
//

import SwiftUI

struct MoviePreparationStepView: View {
    let title: String
    let isComplete: Bool
    let isCurrent: Bool

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Image(systemName: isComplete ? "checkmark" : "circle.fill")
                .font(isComplete ? .footnote.bold() : .system(size: 6))
                .foregroundStyle(isComplete || isCurrent ? Color.accent : .textTertiary)
                .frame(width: 16)

            Text(title)
                .font(.subheadline)
                .fontWeight(isCurrent ? .semibold : .regular)
                .foregroundStyle(isCurrent ? Color.white : .textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
