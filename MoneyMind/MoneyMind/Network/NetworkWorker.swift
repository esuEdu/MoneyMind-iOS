//
//  NetworkWorker.swift
//  MoneyMind
//
//  Created by Eduardo on 29/01/25.
//

import Foundation

// MARK: - Network Worker Protocol
protocol NetworkWorkerProtocol {
    func request<T: Decodable>(_ request: APIRequest, responseType: T.Type) async throws -> T
}

// MARK: - Network Error
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

// MARK: - API Request Protocol
protocol APIRequest {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// MARK: - Network Worker Implementation
actor NetworkWorker: NetworkWorkerProtocol {
    private let session: URLSession
    private let baseURL: URL
    private let decoder: JSONDecoder
    
    init(
        baseURL: URL,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func request<T: Decodable>(_ request: APIRequest, responseType: T.Type) async throws -> T {
        let urlRequest = try buildURLRequest(from: request)
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.requestFailed(statusCode: 0, data: data)
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.requestFailed(statusCode: httpResponse.statusCode, data: data)
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
    
    private func buildURLRequest(from request: APIRequest) throws -> URLRequest {
        let url = baseURL.appendingPathComponent(request.path)
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }
        
        if request.method == .get, let parameters = request.parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        guard let finalURL = components.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = request.method.rawValue
        
        if let headers = request.headers {
            headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        }
        
        if request.method != .get, let parameters = request.parameters {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        
        return urlRequest
    }
}
