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

final class AuthService {
    static let shared = AuthService()
    private let api = ApiClient(baseURL: URL(string: ApiConst.baseUrl)!)
    private init() {}

    func register(name: String, email: String, password: String) async throws
        -> AuthResponse
    {
        let body = RegisterRequest(name: name, email: email, password: password)
        let endpoint = try Endpoint.post(ApiConst.registerUrl, body: body)
        return try await api.send(endpoint)
    }

    func login(email: String, password: String) async throws -> AuthResponse {
        let body = LoginRequest(email: email, password: password)
        let endpoint = try Endpoint.post(ApiConst.loginUrl, body: body)
        return try await api.send(endpoint)
    }

}
