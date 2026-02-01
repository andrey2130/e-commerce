//
//  FavoritesService.swift
//  Ecommerce
//
//  Created by Andrii Duda on 30.01.2026.
//

import Foundation
import SwiftUI

struct FavoritesRequest: Encodable {
    let productId: Int
}

struct FavoritesListResponse: Decodable {
    let success: Bool
    let count: Int
    let data: [FavoriteListItem]
}

struct FavoriteListItem: Identifiable, Decodable {
    let id: Int
    let productId: Int
    let product: FavoriteProduct
    let addedAt: String?
}

struct FavoritesResponse: Decodable {
    let success: Bool
    let data: FavoriteItem
}

struct FavoriteItem: Decodable {
    let id: Int
    let userId: Int?
    let productId: Int
    let createdAt: String?
    let updatedAt: String?
    let product: FavoriteProduct
}

struct FavoriteProduct: Decodable {
    let id: Int
    let name: String
    let price: String
    let images: [String]?
    let category: FavoriteCategory?
}

struct FavoriteCategory: Decodable {
    let id: Int
    let name: String
}

struct FavoritesMessageResponse: Decodable {
    let success: Bool
    let message: String?
}

struct CheckFavoriteResponse: Decodable {
    let success: Bool
    let inFavorites: Bool
}

@Observable
final class FavoritesService {
    static let shared = FavoritesService()
    private let api = ApiClient(baseURL: URL(string: ApiConst.baseUrl)!)

    private(set) var favoriteProductIds: Set<Int> = []

    private init() {}

    @discardableResult
    func loadFavorites(token: String) async throws -> [FavoriteListItem] {
        var endpoint = Endpoint.get(ApiConst.favorites)
        endpoint.headers["Authorization"] = "Bearer \(token)"
        let response: FavoritesListResponse = try await api.send(endpoint)
        favoriteProductIds = Set(response.data.map(\.productId))
        return response.data
    }

    func isFavorite(_ productId: Int) -> Bool {
        favoriteProductIds.contains(productId)
    }

    func checkFavorite(productId: Int, token: String) async throws -> Bool {
        let path = "\(ApiConst.favorites)/check/\(productId)"
        var endpoint = Endpoint.get(path)
        endpoint.headers["Authorization"] = "Bearer \(token)"
        let response: CheckFavoriteResponse = try await api.send(endpoint)
        if response.inFavorites {
            favoriteProductIds.insert(productId)
        } else {
            favoriteProductIds.remove(productId)
        }
        return response.inFavorites
    }

    func addToFavorites(productId: Int, token: String) async throws
        -> FavoritesResponse
    {
        let body = FavoritesRequest(productId: productId)
        var endpoint = try Endpoint.post(ApiConst.favorites, body: body)
        endpoint.headers["Authorization"] = "Bearer \(token)"
        let response: FavoritesResponse = try await api.send(endpoint)
        favoriteProductIds.insert(productId)
        return response
    }

    func removeFromFavorites(productId: Int, token: String) async throws {
        let path = "\(ApiConst.favorites)/\(productId)"
        var endpoint = Endpoint.delete(path)
        endpoint.headers["Authorization"] = "Bearer \(token)"
        let _: FavoritesMessageResponse = try await api.send(endpoint)
        favoriteProductIds.remove(productId)
    }

    func clearFavorites() {
        favoriteProductIds.removeAll()
    }
}
