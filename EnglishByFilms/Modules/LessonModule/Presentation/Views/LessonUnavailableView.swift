//
//  LessonUnavailableView.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 18/09/2026.
//

import SwiftUI

struct LessonUnavailableView: View {
    let title: String
    let message: String
    let retryAction: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: "text.book.closed")
        } description: {
            Text(message)
        } actions: {
            Button("Try again", action: retryAction)
        }
    }
}
