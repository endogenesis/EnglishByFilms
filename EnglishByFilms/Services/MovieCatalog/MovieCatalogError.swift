//
//  MovieCatalogError.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 08/08/2026.
//

import Foundation

enum MovieCatalogError: LocalizedError {
    case missingAccessToken
    case invalidRequest
    case invalidResponse
    case unauthorized
    case rateLimited
    case server(statusCode: Int)
    case invalidData

    var errorDescription: String? {
        switch self {
        case .missingAccessToken:
            "Add the TMDB API Read Access Token to Secrets.json."
        case .invalidRequest:
            "The movie request could not be created."
        case .invalidResponse:
            "The movie service returned an invalid response."
        case .unauthorized:
            "The TMDB access token is invalid."
        case .rateLimited:
            "Too many movie requests. Please try again shortly."
        case .server:
            "The movie service is temporarily unavailable."
        case .invalidData:
            "The movie service returned data in an unexpected format."
        }
    }
}
