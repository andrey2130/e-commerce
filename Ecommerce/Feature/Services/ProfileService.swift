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

final class ProfileService: ProfileServiceProtocol {

    private let api: ApiClient
    init(api: ApiClient) {
        self.api = api
    }

    func getUserData(token: String) async throws -> UserModel {
        var endpoint = Endpoint.get(ApiConst.getUserInfo)
        endpoint.headers["Authorization"] = "Bearer \(token)"

        let response: UserInfoResponse = try await api.send(endpoint)
        return response.user
    }

}
