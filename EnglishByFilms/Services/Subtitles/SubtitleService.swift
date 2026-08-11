//
//  SubtitleService.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 11/08/2026.
//

nonisolated protocol SubtitleService: Sendable {
    func searchEnglishSubtitles(tmdbMovieID: Int, page: Int) async throws -> SubtitlePage

    func downloadSubtitle(fileID: Int) async throws -> DownloadedSubtitle
}
