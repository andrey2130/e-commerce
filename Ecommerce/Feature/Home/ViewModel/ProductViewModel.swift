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
    var canLoadMore: Bool = true
    var currentPage: Int = 1
    private let productService: ProductService = .shared

    func loadProducts() async {
        guard canLoadMore else { return }

        do {
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
            self.loadingState = .error(error)
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
}
