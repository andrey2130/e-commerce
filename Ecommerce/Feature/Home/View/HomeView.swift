//
//  HomeView.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//

import SwiftUI

struct HomeView: View {

    @State private var viewModel = ProductViewModel()
    @Environment(Coordinator.self) private var coordinator

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        VStack {
            switch viewModel.productsState {

            case .idle, .loading:
                ProgressView()

            case .loaded(let products):
                content(products: products)

            case .empty:
                emptyState

            case .error:
                errorState
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            if case .idle = viewModel.productsState {
                await viewModel.loadProducts()
            }
        }
    }
}

// MARK: - Content

private extension HomeView {

    func content(products: [ProductModel]) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header
                grid(products: products)
            }
            .padding(.horizontal, 16)
        }
    }

    var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Discover")
                .font(AppFont.largeTitle)

            Text("Find your prefect items")
                .font(AppFont.subTitle)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    func grid(products: [ProductModel]) -> some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(products) { product in
                ProductCard(
                    product: product,
                    onFavoriteToggle: {
                        Task {
                            if viewModel.favoriteService.isFavorite(product.id) {
                                try await viewModel.deleteFavorites(id: product.id)
                            } else {
                                await viewModel.setAsFavorites(id: product.id)
                            }
                        }
                    },
                    isFavorite: viewModel.favoriteService.isFavorite(product.id)
                ) {
                    coordinator.push(.productDetails(id: product.id))
                }
                .task {
                    await viewModel.loadMoreIfNeeded(currentItem: product)
                }
            }
            .padding(.top, 16)
        }
    }
}

// MARK: - States

private extension HomeView {

    var emptyState: some View {
        VStack(spacing: 12) {
            Text("No data loaded")
                .font(AppFont.subTitle)

            Button("Reload") {
                Task { await viewModel.loadProducts() }
            }
        }
    }

    var errorState: some View {
        ErrorState {
            Task {
                await viewModel.loadProducts()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    HomeView()
}
