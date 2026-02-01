//
//  FavoritesViewModel.swift
//  Ecommerce
//
//  Created by Andrii Duda on 01.02.2026.
//

import SwiftUI

@Observable
@MainActor
class FavoritesViewModel {
    private let localStorage: LocalStorageService = .shared
    let favoriteService: FavoritesService = .shared
    var favoritesProducts: [FavoriteListItem] = []
    var isLoading = false
    var error: Error?

    private var token: String? {
        localStorage.getToken()?.isEmpty == false
            ? localStorage.getToken()
            : nil
    }

    func setAsFavorites(id: Int) async {
        guard let token else { return }

        do {
            let response = try await favoriteService.addToFavorites(
                productId: id,
                token: token
            )

            let newItem = FavoriteListItem(
                id: response.data.id,
                productId: response.data.productId,
                product: response.data.product,
                addedAt: response.data.createdAt
            )
            favoritesProducts.append(newItem)
        } catch {
            self.error = error
            print(error.localizedDescription)
        }
    }

    func deleteFavorites(id: Int) async {
        guard let token else { return }

        do {
            try await favoriteService.removeFromFavorites(
                productId: id,
                token: token
            )

            favoritesProducts.removeAll { $0.productId == id }
        } catch {
            self.error = error
            print("error deleting favorites \(error.localizedDescription)")
        }
    }

    func loadFavorites() async {
        guard let token = localStorage.getToken(), !token.isEmpty else {
            return
        }

        isLoading = true
        error = nil

        do {
            favoritesProducts = try await favoriteService.loadFavorites(
                token: token
            )
        } catch {
            self.error = error
            print("error loading favorites \(error.localizedDescription)")
        }

        isLoading = false
    }
}
