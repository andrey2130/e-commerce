import Factory
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
    var inCart: Bool = false

    @ObservationIgnored @Injected(\.productService) private var productService
    @ObservationIgnored @Injected(\.localStorageService) private var localStorage
    @ObservationIgnored @Injected(\.favoritesService) private var favoriteService
    @ObservationIgnored @Injected(\.cartService) private var cartService
    var pagination = Pagination()

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
    
    
    private func preloadCartIfNeeded() async {
        guard let token,
              cartService.cartProductIds.isEmpty
        else { return }
        
        do {
            var cartProduct = try await cartService.getCart(token: token)
            print("Cart product = \(cartProduct)")
        } catch {
            print("Cart preload error:", error.localizedDescription)
        }
    }

    func loadProducts() async {
        guard pagination.canLoadMore else { return }

        await preloadFavoritesIfNeeded()
        await preloadCartIfNeeded()

        do {
            let response = try await productService.getProduct(
                page: pagination.page,
                limit: 10
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
        await preloadCartIfNeeded()

        do {
            let response = try await productService.getProductById(id)
            selectedProduct = response.data
            inCart = cartService.cartProductIds.contains(id)
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

    func addToCart(productId: Int, count: Int = 1) async {
        guard let token else { return }

        do {
            _ = try await cartService.addProductToCart(
                productId: productId,
                count: count,
                token: token
            )
            inCart = true
        } catch {
            print(error.localizedDescription)
            productDetailsState = .error(error)
        }
    }
    


    func removeFromCart(cartItemId: Int, productId: Int) async {
        guard let token else { return }

        do {
            try await cartService.removeFromCart(
                cartItemId: cartItemId,
                productId: productId,
                token: token
            )
            inCart = false
        } catch {
            productDetailsState = .error(error)
        }
    }
}
