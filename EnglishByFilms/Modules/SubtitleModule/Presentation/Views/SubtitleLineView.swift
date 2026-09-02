//
//  SubtitleLineView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 29/08/2026.
//

import SwiftUI

struct SubtitleLineView: View {
    let text: String
    let distance: Int

    var body: some View {
        Text(text)
            .font(isActive ? .title2 : .subheadline)
            .bold(isActive)
            .foregroundStyle(color)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
    }

    private var isActive: Bool {
        distance == 0
    }

    private var color: Color {
        switch abs(distance) {
        case 0:
            .white
        case 1:
            .textSecondary
        default:
            .textTertiary
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        SubtitleLineView(text: "Tumbling down the rabbit hole?", distance: -1)
        SubtitleLineView(text: "Do you believe in fate, Neo?", distance: 0)
        SubtitleLineView(text: "No.", distance: 1)
        SubtitleLineView(text: "Why not?", distance: 2)
    }
    .padding(24)
    .background(.backgroundBase)
    .preferredColorScheme(.dark)
}
