//
//  APIError.swift
//  APIManager
//
//  Created by Pooja Sadariwala on 15/09/25.
//

import Foundation

public enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(statusCode: Int)
    case networkUnavailable
    case unknown(Error)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .invalidResponse:
            return "Invalid server response."
        case .decodingError:
            return "Failed to decode response."
        case .serverError(let code):
            return "Server returned error code \(code)."
        case .networkUnavailable:
            return "Network connection is not available."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
