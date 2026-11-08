//
//  LessonHeaderView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 20/09/2026.
//

import SwiftUI

struct LessonHeaderView: View {
    let progress: Double
    let close: () -> Void

    var body: some View {
        HStack(spacing: 20) {
            Button("Close lesson", systemImage: "xmark", action: close)
                .labelStyle(.iconOnly)
                .foregroundStyle(.textSecondary)
                .frame(width: 20, height: 24)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.white.opacity(0.12))

                    Capsule()
                        .fill(.accent)
                        .frame(width: geometry.size.width * CGFloat(clampedProgress))
                        .animation(.easeInOut(duration: 0.3), value: clampedProgress)
                }
            }
            .frame(height: 5)
        }
        .padding(EdgeInsets(top: 16, leading: 24, bottom: 24, trailing: 24))
    }

    private var clampedProgress: Double {
        min(max(progress, 0), 1)
    }
}

#Preview {
    LessonHeaderView(progress: 0.25, close: { })
        .background(.backgroundBase)
        .preferredColorScheme(.dark)
}

struct ProgressView: View {
    var body: some View {
        Text("s")
    }
}
