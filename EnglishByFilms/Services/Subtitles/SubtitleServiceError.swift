//
//  SubtitleServiceError.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 11/08/2026.
//

import Foundation

enum SubtitleServiceError: LocalizedError {
    case missingAPIKey
    case invalidRequest
    case invalidResponse
    case unauthorized
    case accessDenied
    case downloadLimitReached
    case rateLimited
    case unavailable
    case server(statusCode: Int)
    case invalidData

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            "Add the OpenSubtitles API key to Secrets.json."
        case .invalidRequest:
            "The subtitle request could not be created."
        case .invalidResponse:
            "The subtitle service returned an invalid response."
        case .unauthorized:
            "The OpenSubtitles API key is invalid."
        case .accessDenied:
            "OpenSubtitles denied access to this request."
        case .downloadLimitReached:
            "The subtitle download limit has been reached."
        case .rateLimited:
            "Too many subtitle requests. Please try again shortly."
        case .unavailable:
            "The requested subtitle is no longer available."
        case .server:
            "The subtitle service is temporarily unavailable."
        case .invalidData:
            "The subtitle service returned data in an unexpected format."
        }
    }
}
