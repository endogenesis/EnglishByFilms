//
//  SearchPaginationFailureView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 14/08/2026.
//

import SwiftUI

struct SearchPaginationFailureView: View {
    let message: String
    let retry: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Text("Couldn't load more movies")
                .font(.subheadline.weight(.semibold))

            Text(message)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Retry", action: retry)
                .buttonStyle(.bordered)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }
}

#Preview("Pagination failure") {
    SearchPaginationFailureView(
        message: "The Internet connection appears to be offline.",
        retry: { }
    )
    .padding(.horizontal, 24)
    .background(.backgroundBase)
    .preferredColorScheme(.dark)
}
