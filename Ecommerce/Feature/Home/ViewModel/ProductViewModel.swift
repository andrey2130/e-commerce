//
//  ProductViewModel.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//
import SwiftUI

@Observable
@MainActor
final class ProductViewModel {
    var products: [ProductModel] = []
    var loadingState: ContentLoadingState = .loading
    var detailsState: DetailsLoadingState = .loading
    var canLoadMore: Bool = true
    var currentPage: Int = 1
    var selectedProduct: ProductModel?

    private let productService: ProductService = .shared
    private let localStorage: LocalStorageService = .shared
    let favoriteService: FavoritesService = .shared

    private func preloadFavoritesIfNeeded() async {
        guard let token = localStorage.getToken(), !token.isEmpty else {
            return
        }

        guard favoriteService.favoriteProductIds.isEmpty else {
            return
        }

        do {
            try await favoriteService.loadFavorites(token: token)
        } catch {
            print("Favorites preload error:", error.localizedDescription)
        }
    }

    func loadProducts() async {
        guard canLoadMore else { return }

        do {
            await preloadFavoritesIfNeeded()
            let response = try await productService.getProduct(
                page: currentPage
            )
            let newItems = response.data

            if newItems.isEmpty {
                canLoadMore = false
                return
            }

            let existingIds = Set(products.map(\.id))
            let uniqueNewItems = newItems.filter {
                !existingIds.contains($0.id)
            }

            products.append(contentsOf: uniqueNewItems)
            currentPage += 1
            self.loadingState = products.isEmpty ? .empty : .completed
            print("state: \(self.loadingState)")
        } catch {
            print("error = \(error.localizedDescription)")
            self.loadingState = .error(error)
        }
    }

    func loadProductDetails(id: Int) async {
        detailsState = .loading

        await preloadFavoritesIfNeeded()

        do {
            let response = try await productService.getProductById(id)
            selectedProduct = response.data
            detailsState = .completed
        } catch {
            detailsState = .error(error)
        }
    }

    func loadMore(currentItem item: ProductModel?) async {

        guard let item = item,
            canLoadMore,
            products.count >= 5
        else { return }

        let thresholdIndex = products.index(products.endIndex, offsetBy: -1)
        if let index = products.firstIndex(where: { $0.id == item.id }),
            index >= thresholdIndex
        {
            await loadProducts()
        }

    }

    func setAsFavorites(id: Int) async throws {
        guard let token = localStorage.getToken(), !token.isEmpty else {
            return
        }

        do {
            _ = try await favoriteService.addToFavorites(
                productId: id,
                token: token
            )

        } catch {
            print(error.localizedDescription)
        }

    }

    func deleteFavorites(id: Int) async throws {
        guard let token = localStorage.getToken(), !token.isEmpty else {
            return
        }
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
