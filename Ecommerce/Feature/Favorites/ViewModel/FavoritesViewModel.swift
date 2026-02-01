//
//  FavoritesViewModel.swift
//  Ecommerce
//
//  Created by Andrii Duda on 01.02.2026.
//

import SwiftUI

@MainActor
@Observable
class FavoritesViewModel {
    private let localStorage: LocalStorageService = .shared
    let favoriteService: FavoritesService = .shared

    private var token: String? {
        localStorage.getToken()?.isEmpty == false
            ? localStorage.getToken()
            : nil
    }

    func setAsFavorites(id: Int) async {
        guard let token else { return }

        do {
            _ = try await favoriteService.addToFavorites(
                productId: id,
                token: token
            )

        } catch {
            print(error.localizedDescription)
        }

    }

    func deleteFavorites(id: Int) async {
        guard let token else { return }
        do {
            _ = try await favoriteService.removeFromFavorites(
                productId: id,
                token: token
            )
        } catch {
            print("error deleting favorites \(error.localizedDescription)")
        }
    }

    func loadFavorites() async throws {
        guard let token = localStorage.getToken(), !token.isEmpty else {
            return
        }
        do {
            _ = try await favoriteService.loadFavorites(token: token)
        } catch {
            print("error loading favorites \(error.localizedDescription)")
        }
    }
}
