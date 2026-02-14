//
//  ProductViewModel.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//
import Factory
import SwiftUI

@Observable
@MainActor
final class ProductViewModel {
    @ObservationIgnored @Injected(\.productService) private var productService
    @ObservationIgnored @Injected(\.localStorageService) private var localStorage
    @ObservationIgnored @Injected(\.favoritesService) private var favoriteService
    @ObservationIgnored @Injected(\.cartService) private var cartService
    @ObservationIgnored @Injected(\.categoriesService) private var categoryService

    var products: [ProductModel] = []
    var categories: [CategoryModel] = []
    var selectedCategory: Int? = nil
    var searchResults: [ProductModel] = []
    var productsState: Loadable<[ProductModel]> = .idle
    var productDetailsState: Loadable<ProductModel> = .idle
    var canLoadMore: Bool = true
    var currentPage: Int = 1
    var selectedProduct: ProductModel?
    var pagination = Pagination()
    var searchPagination = Pagination()
    var searchText: String = ""
    
    var isSearching: Bool {
        !searchText.isEmpty
    }

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
            let response: ProductListModel
            
            if let categoryId = selectedCategory {
                response = try await productService.getProductsByCategory(
                    page: pagination.page,
                    limit: 10,
                    categoryId: categoryId
                )
            } else {
                response = try await productService.getProduct(
                    page: pagination.page,
                    limit: 10
                )
            }

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
    
    func loadCategories() async {
        do {
            let response = try await categoryService.getCategories()
            categories = response.data
        } catch {
            print("Error loading categories: \(error)")
        }
    }
    
    func filterByCategory(_ categoryId: Int?) {
        selectedCategory = categoryId
        
        products.removeAll()
        pagination.reset()
        productsState = .idle
        
        Task {
            await loadProducts()
        }
    }

    func searchProducts(reset: Bool = false) async {
        guard !searchText.isEmpty else { return }

        if reset {
            searchPagination.reset()
            searchResults.removeAll()
        }

        guard searchPagination.canLoadMore else { return }

        do {
            let response = try await productService.searchProduct(
                page: searchPagination.page,
                limit: 10,
                search: searchText
            )

            let newItems = response.data
            guard !newItems.isEmpty else {
                searchPagination.stop()
                return
            }
            searchResults.append(contentsOf: newItems)

            searchPagination.nextPage()
        } catch {
            print("searching error")
        }

        searchPagination.isLoadingMore = false
    }

    func loadProductDetails(id: Int) async {
        productDetailsState = .loading
        await preloadFavoritesIfNeeded()
        await preloadCartIfNeeded()

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

    func loadMoreSearchIfNeeded(currentItem item: ProductModel?) async {
        guard
            let item,
            searchPagination.canLoadMore,
            let last = searchResults.last,
            !searchPagination.isLoadingMore,
            last.id == item.id
        else { return }

        searchPagination.isLoadingMore = true
        await searchProducts()
    }

    private func preloadCartIfNeeded() async {
        guard let token,
            cartService.cartProductIds.isEmpty
        else { return }

        do {
            _ = try await cartService.getCart(token: token)
        } catch {
            print("Cart preload error:", error.localizedDescription)
        }
    }

    var displayedProducts: [ProductModel] {
        if searchText.isEmpty {
            return products
        } else {
            return searchResults
        }
    }
}
