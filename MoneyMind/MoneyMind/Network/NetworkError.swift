//
//  NetworkError.swift
//  MoneyMind
//
//  Created by Eduardo on 29/01/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case noInternetConnection
    case invalidURL
    case requestFailed(statusCode: Int, data: Data?)
    case decodingFailed
    case custom(message: String)
    
    var errorDescription: String? {
        switch self {
        case .noInternetConnection: return "Please check your internet connection"
        case .invalidURL: return "Invalid URL format"
        case .requestFailed(let statusCode, _): return "Request failed with status code: \(statusCode)"
        case .decodingFailed: return "Failed to decode response"
        case .custom(let message): return message
        }
    }
}
