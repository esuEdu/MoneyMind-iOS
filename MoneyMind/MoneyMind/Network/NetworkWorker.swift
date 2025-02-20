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


// MARK: - API Request Protocol
protocol APIRequest {
    var baseURL: URL { get }
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

// MARK: - Network Worker
actor NetworkWorker: NetworkWorkerProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
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
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Response JSON:\n\(jsonString)")
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
    
    private func buildURLRequest(from request: APIRequest) throws -> URLRequest {
        let url = request.baseURL.appendingPathComponent(request.path)
        
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
