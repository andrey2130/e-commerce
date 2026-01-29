//
//  ProfileService.swift
//  Ecommerce
//
//  Created by Andrii Duda on 29.01.2026.
//

import Foundation

struct UserInfoResponse: Decodable {
    let success: Bool
    let user: UserModel
}

class ProfileService {
    static let shared = ProfileService()
    private let api = ApiClient(baseURL: URL(string: AppiConts.baseUrl)!)

    private init() {}

    func getUserData(token: String) async throws -> UserModel {
        var endpoint = Endpoint.get(AppiConts.getUserInfo)
        endpoint.headers["Authorization"] = "Bearer \(token)"

        let response: UserInfoResponse = try await api.send(endpoint)
        return response.user
    }

}
