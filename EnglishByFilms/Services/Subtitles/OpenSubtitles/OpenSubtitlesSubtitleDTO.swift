//
//  OpenSubtitlesSubtitleDTO.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 11/08/2026.
//

nonisolated struct OpenSubtitlesSearchResponseDTO: Decodable {
    let totalPages: Int
    let page: Int
    let data: [OpenSubtitlesSubtitleDTO]

    private enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case page
        case data
    }

    func toDomain() -> SubtitlePage {
        SubtitlePage(
            subtitles: data.flatMap(\.subtitles),
            currentPage: page,
            totalPages: totalPages
        )
    }
}

nonisolated struct OpenSubtitlesSubtitleDTO: Decodable {
    let attributes: OpenSubtitlesSubtitleAttributesDTO

    var subtitles: [SubtitleSummary] {
        attributes.files.compactMap { file in
            guard let fileID = file.fileID, fileID > 0, let fileName = file.fileName else {
                return nil
            }

            return SubtitleSummary(
                fileID: fileID,
                fileName: fileName,
                releaseName: attributes.releaseName ?? fileName,
                languageCode: attributes.languageCode ?? "",
                downloadCount: attributes.downloadCount ?? 0,
                rating: attributes.rating ?? 0,
                hearingImpaired: attributes.hearingImpaired ?? false,
                fromTrustedSource: attributes.fromTrustedSource ?? false,
                machineTranslated: attributes.machineTranslated ?? false,
                aiTranslated: attributes.aiTranslated ?? false
            )
        }
    }
}

nonisolated struct OpenSubtitlesSubtitleAttributesDTO: Decodable {
    let languageCode: String?
    let downloadCount: Int?
    let hearingImpaired: Bool?
    let rating: Double?
    let fromTrustedSource: Bool?
    let machineTranslated: Bool?
    let aiTranslated: Bool?
    let releaseName: String?
    let files: [OpenSubtitlesFileDTO]

    private enum CodingKeys: String, CodingKey {
        case languageCode = "language"
        case downloadCount = "download_count"
        case hearingImpaired = "hearing_impaired"
        case rating = "ratings"
        case fromTrustedSource = "from_trusted"
        case machineTranslated = "machine_translated"
        case aiTranslated = "ai_translated"
        case releaseName = "release"
        case files
    }
}

nonisolated struct OpenSubtitlesFileDTO: Decodable {
    let fileID: Int?
    let fileName: String?

    private enum CodingKeys: String, CodingKey {
        case fileID = "file_id"
        case fileName = "file_name"
    }
}
