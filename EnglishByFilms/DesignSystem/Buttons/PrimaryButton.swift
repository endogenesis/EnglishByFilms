//
//  PrimaryButton.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 09/08/2026.
//

import SwiftUI

struct PrimaryButton: View {
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
                .background(.fillCTA, in: .capsule)
                .contentShape(.capsule)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PrimaryButton("Start learning") { }
        .padding(24)
        .background(.backgroundBase)
}
