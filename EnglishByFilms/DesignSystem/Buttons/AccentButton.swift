//
//  AccentButton.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 09/08/2026.
//

import SwiftUI

struct AccentButton: View {
    private let title: String
    private let action: () -> Void

    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.backgroundBase)
                .frame(maxWidth: .infinity, minHeight: 56)
                .background(.accent, in: .capsule)
                .contentShape(.capsule)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AccentButton("Continue") { }
        .padding(24)
        .background(.backgroundBase)
}
