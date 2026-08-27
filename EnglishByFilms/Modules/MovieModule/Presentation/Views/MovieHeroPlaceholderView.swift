//
//  MovieHeroPlaceholderView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 15/08/2026.
//

import SwiftUI

struct MovieHeroPlaceholderView: View {
    let title: String

    var body: some View {
        ZStack {
            Color.backgroundCard

            Circle()
                .fill(Color.indigo.opacity(0.55))
                .frame(width: 260, height: 260)
                .blur(radius: 45)
                .offset(x: -100, y: -60)

            Circle()
                .fill(Color.orange.opacity(0.35))
                .frame(width: 220, height: 220)
                .blur(radius: 50)
                .offset(x: 120, y: 70)
        }
        .clipped()
    }
}

#Preview {
    MovieHeroPlaceholderView(title: "The Matrix")
        .frame(height: 280)
        .preferredColorScheme(.dark)
}


