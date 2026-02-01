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
    var pagination = Pagination()
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
            
            _ = try await favoriteService.loadFavorites(token: token)
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
                pagination.isLoadingMore = false
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

        pagination.isLoadingMore = false
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
            !pagination.isLoadingMore,
            last.id == item.id
        else { return }
        pagination.isLoadingMore = true

        await loadProducts()
    }

}
