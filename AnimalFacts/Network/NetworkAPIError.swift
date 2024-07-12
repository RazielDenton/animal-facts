//
//  NetworkError.swift
//  AnimalFacts
//
//  Created by Viacheslav on 12.07.2024.
//

import Foundation

public enum NetworkAPIError: Equatable, LocalizedError, Sendable {

    case invalidURL
    case unableToParseData
    case serverError(String)
    case unknown

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The provided URL was invalid."
        case .unableToParseData:
            return "We were unable to parse the data received from the server."
        case .serverError(let message):
            return "Server error: \(message)"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
