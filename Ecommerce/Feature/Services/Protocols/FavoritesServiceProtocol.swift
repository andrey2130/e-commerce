//
//  FavoritesServiceProtocol.swift
//  Ecommerce
//
//  Created by Andrii Duda on 02.02.2026.
//

protocol FavoritesServiceProtocol {
    var favoriteProductIds: Set<Int> { get }

    func loadFavorites(token: String) async throws -> [FavoriteListItem]

    func isFavorite(_ productId: Int) -> Bool

    func checkFavorite(productId: Int, token: String) async throws -> Bool

    func addToFavorites(productId: Int, token: String) async throws
        -> FavoritesResponse

    func removeFromFavorites(productId: Int, token: String) async throws

    func clearFavorites()
}
