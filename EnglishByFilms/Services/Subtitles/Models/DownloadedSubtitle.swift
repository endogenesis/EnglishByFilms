//
//  DownloadedSubtitle.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 11/08/2026.
//

import Foundation

struct DownloadedSubtitle: Equatable {
    let fileName: String
    let data: Data
    let remainingDownloads: Int
    let quotaResetDate: Date?
}
