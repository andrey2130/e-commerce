//
//  ProfileServiceProtocol.swift
//  Ecommerce
//
//  Created by Andrii Duda on 02.02.2026.
//

protocol ProfileServiceProtocol {
    func getUserData(token: String) async throws -> UserModel
}
