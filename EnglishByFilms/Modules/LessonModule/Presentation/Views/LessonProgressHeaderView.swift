//
//  LessonProgressHeaderView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 18/09/2026.
//

import SwiftUI

struct LessonProgressHeaderView: View {
    let eyebrow: String
    let title: String
    let currentIndex: Int
    let totalCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(eyebrow)
                    .font(.caption.bold())
                    .tracking(1.2)
                    .foregroundStyle(.accent)

                Spacer()

                Text("\(currentIndex + 1) of \(totalCount)")
                    .font(.subheadline)
                    .foregroundStyle(.textTertiary)
                    .monospacedDigit()
            }

            Text(title)
                .font(.title.bold())
        }
    }
}
