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
    let rating: Double
    let hearingImpaired: Bool
    let fromTrustedSource: Bool
    let machineTranslated: Bool
    let aiTranslated: Bool

    var id: Int {
        fileID
    }
}
