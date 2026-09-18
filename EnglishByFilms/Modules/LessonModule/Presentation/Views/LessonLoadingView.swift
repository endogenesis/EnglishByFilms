//
//  LessonLoadingView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 18/09/2026.
//

import SwiftUI

struct LessonLoadingView: View {
    let movieTitle: String

    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .controlSize(.large)
                .tint(.accent)

            Text("Creating your lesson…")
                .font(.title3.bold())

            Text(movieTitle)
                .font(.subheadline)
                .foregroundStyle(.textSecondary)
        }
        .padding(24)
    }
}

#Preview {
    LessonLoadingView(movieTitle: "The Matrix")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.backgroundBase)
        .preferredColorScheme(.dark)
}
