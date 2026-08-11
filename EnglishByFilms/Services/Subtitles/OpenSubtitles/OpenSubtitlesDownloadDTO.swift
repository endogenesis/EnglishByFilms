//
//  OpenSubtitlesDownloadDTO.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 11/08/2026.
//

import Foundation

nonisolated struct OpenSubtitlesDownloadRequestDTO: Encodable {
    let fileID: Int

    private enum CodingKeys: String, CodingKey {
        case fileID = "file_id"
    }
}

nonisolated struct OpenSubtitlesDownloadResponseDTO: Decodable {
    let link: URL
    let fileName: String
    let remainingDownloads: Int
    let resetTimeUTC: String?

    private enum CodingKeys: String, CodingKey {
        case link
        case fileName = "file_name"
        case remainingDownloads = "remaining"
        case resetTimeUTC = "reset_time_utc"
    }
}
