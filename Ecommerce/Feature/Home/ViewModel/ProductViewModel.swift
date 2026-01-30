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
    var productsState: Loadable<[ProductModel]> = .idle
    var productDetailsState: Loadable<ProductModel> = .idle
    var canLoadMore: Bool = true
    var currentPage: Int = 1
    var selectedProduct: ProductModel?

    private let productService: ProductService = .shared
    private let localStorage: LocalStorageService = .shared
    private var pagination = Pagination()
    let favoriteService: FavoritesService = .shared

    private var token: String? {
        localStorage.getToken()?.isEmpty == false
            ? localStorage.getToken()
            : nil
    }

    private func preloadFavoritesIfNeeded() async {
        guard let token,
            favoriteService.favoriteProductIds.isEmpty
        else { return }

        do {
            try await favoriteService.loadFavorites(token: token)
        } catch {
            print("Favorites preload error:", error.localizedDescription)
        }
    }

    func loadProducts() async {
        guard pagination.canLoadMore else { return }

        await preloadFavoritesIfNeeded()

        do {
            let response = try await productService.getProduct(
                page: pagination.page
            )

            let newItems = response.data
            guard !newItems.isEmpty else {
                pagination.stop()
                productsState = products.isEmpty ? .empty : .loaded(products)
                return
            }

            let existingIds = Set(products.map(\.id))
            let uniqueItems = newItems.filter { !existingIds.contains($0.id) }

            products.append(contentsOf: uniqueItems)
            pagination.nextPage()

            productsState = .loaded(products)
        } catch {
            productsState = .error(error)
        }
    }

    func loadProductDetails(id: Int) async {
        productDetailsState = .loading
        await preloadFavoritesIfNeeded()

        do {
            let response = try await productService.getProductById(id)
            selectedProduct = response.data
            productDetailsState = .loaded(response.data)
        } catch {
            productDetailsState = .error(error)
        }
    }

    func loadMoreIfNeeded(currentItem item: ProductModel?) async {
        guard
            let item,
            pagination.canLoadMore,
            let last = products.last,
            last.id == item.id
        else { return }

        await loadProducts()
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

    func deleteFavorites(id: Int) async  {
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
