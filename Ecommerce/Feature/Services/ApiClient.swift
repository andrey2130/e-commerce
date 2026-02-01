//
//  ApiClient.swift
//  Ecommerce
//
//  Created by Andrii Duda on 29.01.2026.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct Endpoint {
    var path: String
    var method: HTTPMethod
    var query: [URLQueryItem] = []
    var headers: [String: String] = [:]
    var body: Data? = nil

    static func get(_ path: String, query: [URLQueryItem] = []) -> Endpoint {
        Endpoint(path: path, method: .get, query: query)
    }

    static func post<T: Encodable>(_ path: String, body: T) throws -> Endpoint {
        var e = Endpoint(path: path, method: .post)
        e.body = try JSONEncoder().encode(body)
        e.headers["Content-Type"] = "application/json"
        return e
    }

    static func delete(_ path: String) -> Endpoint {
        Endpoint(path: path, method: .delete)
    }
}

final class ApiClient {
    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func send<T: Decodable>(_ endpoit: Endpoint) async throws -> T {
        guard
            var components = URLComponents(
                url: baseURL.appendingPathComponent(endpoit.path),
                resolvingAgainstBaseURL: false
            )
        else {
            throw NetworkError.invalidURL
        }
        if !endpoit.query.isEmpty {
            components.queryItems = endpoit.query
        }
        guard let url = components.url else {
            print("Invalid URl ")
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoit.method.rawValue

        endpoit.headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        if endpoit.body != nil {
            request.httpBody = endpoit.body
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue(
                    "application/json",
                    forHTTPHeaderField: "Content-Type"
                )
            }
        }

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(http.statusCode) else {
            print("error \(http.statusCode)")
            throw NetworkError.serverError(statusCode: http.statusCode)
        }
        do {
            print(String(data: data, encoding: .utf8) ?? "")
            return try JSONDecoder().decode(T.self, from: data)

        } catch {
            print("errors \(error.localizedDescription)")
            throw NetworkError.decodingError
        }
    }
}
