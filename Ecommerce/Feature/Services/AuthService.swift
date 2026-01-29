//
//  AuthService.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//

import Foundation

struct RegisterRequest: Codable {
    let name: String
    let email: String
    let password: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct AuthResponse: Codable {
    let success: Bool
    let token: String?
    let user: UserModel

}

class AuthService {
    static let shared = AuthService()

    private init() {}

    func register(name: String, email: String, password: String) async throws
        -> AuthResponse
    {
        guard let url = URL(string: AppiConts.registerUrl) else {
            throw NetworkError.invalidURL
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print(request)

        let body = RegisterRequest(name: name, email: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }

        let authResponce = try JSONDecoder().decode(
            AuthResponse.self,
            from: data
        )
        print(authResponce)
        return authResponce
    }

    func login(email: String, password: String) async throws -> AuthResponse {
        guard let url = URL(string: AppiConts.loginUrl) else {
            throw NetworkError.invalidURL
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print(request)

        let body = LoginRequest(email: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }

        let authResponce = try JSONDecoder().decode(
            AuthResponse.self,
            from: data
        )
        print(authResponce)
        return authResponce
    }

}
