//
//  SubtitleSummary.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 11/08/2026.
//

struct SubtitleSummary: Identifiable, Equatable {
    let fileID: Int
    let fileName: String
    let releaseName: String
    let languageCode: String
    let downloadCount: Int
    let newDownloadCount: Int
    let rating: Double
    let hearingImpaired: Bool
    let fromTrustedSource: Bool
    let foreignPartsOnly: Bool
    let machineTranslated: Bool
    let aiTranslated: Bool
    let fileCount: Int

    var id: Int {
        fileID
    }
}
