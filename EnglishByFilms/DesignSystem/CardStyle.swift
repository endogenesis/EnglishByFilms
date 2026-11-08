//
//  CardStyle.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 08/11/2026.
//

import SwiftUI

struct CardStyle: ViewModifier {
    var cornerRadius: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .background(
                Color(red: 25 / 255, green: 26 / 255, blue: 34 / 255),
                in: RoundedRectangle(cornerRadius: cornerRadius)
            )
    }
}

extension View {
    func cardStyle(cornerRadius: CGFloat = 16) -> some View {
        modifier(CardStyle(cornerRadius: cornerRadius))
    }
}
