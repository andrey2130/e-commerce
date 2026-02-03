//
//  FavoritesViewModel.swift
//  Ecommerce
//
//  Created by Andrii Duda on 01.02.2026.
//

import Factory
import SwiftUI

enum FavoritesState: Equatable {
    case loading
    case loaded([FavoriteListItem])
    case empty
    case error

    static func == (lhs: FavoritesState, rhs: FavoritesState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading),
            (.loaded, .loaded),
            (.empty, .empty),
            (.error, .error):
            return true
        default:
            return false
        }
    }
}

@Observable
@MainActor
class FavoritesViewModel {
    @ObservationIgnored @Injected(\.localStorageService) private
        var localStorageService
    @ObservationIgnored @Injected(\.favoritesService) private
        var favoriteService

    private(set) var favoritesProducts: [FavoriteListItem] = []
    private(set) var favoriteState: FavoritesState = .loading

    private var token: String? {
        localStorageService.getToken()?.isEmpty == false
            ? localStorageService.getToken()
            : nil
    }

    func isFavorite(_ id: Int) -> Bool {
        favoriteService.isFavorite(id)
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
            updateState()

        } catch {
            favoriteState = .error
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
            updateState()

        } catch {
            favoriteState = .error
            print("error deleting favorites \(error.localizedDescription)")
        }
    }

    func loadFavorites() async {
        guard let token = localStorageService.getToken(), !token.isEmpty else {
            favoriteState = .empty
            return
        }

        favoriteState = .loading

        do {
            favoritesProducts = try await favoriteService.loadFavorites(
                token: token
            )
            updateState()
        } catch {
            favoriteState = .error
            print("error loading favorites \(error.localizedDescription)")
        }
    }

    private func updateState() {
        favoriteState =
            favoritesProducts.isEmpty ? .empty : .loaded(favoritesProducts)
    }

    func clearFavorites() {
        favoritesProducts.removeAll()
        favoriteService.clearFavorites()
        favoriteState = .empty
    }
}
