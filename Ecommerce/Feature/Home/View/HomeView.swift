//
//  HomeView.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = ProductViewModel()
    @State private var showAuthAlert: Bool = false
    @Environment(Coordinator.self) private var coordinator
    @Environment(AuthViewModel.self) private var auth
    @Environment(FavoritesViewModel.self) private var favoriteViewModel
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
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
        .alert("Login required", isPresented: $showAuthAlert) {
            Button("Login") {
                coordinator.push(.login)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("You need to be logged in to add products to favorites.")
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

extension HomeView {

    fileprivate func content(products: [ProductModel]) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header
                grid(products: products)

                if viewModel.pagination.isLoadingMore {
                    HStack {
                        Spacer()
                        ProgressView()
                            .padding(.vertical, 20)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    fileprivate var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Discover")
                .font(AppFont.largeTitle)

            Text("Find your prefect items")
                .font(AppFont.subTitle)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    fileprivate func grid(products: [ProductModel]) -> some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(products) { product in
                ProductCard(
                    product: product,
                    onFavoriteToggle: {
                        if auth.state == .unauthorized {
                            showAuthAlert = true
                            return
                        }
                        Task {
                            if viewModel.favoriteService.isFavorite(product.id)
                            {
                                await favoriteViewModel.deleteFavorites(
                                    id: product.id
                                )
                            } else {
                                await favoriteViewModel.setAsFavorites(
                                    id: product.id
                                )
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

extension HomeView {

    fileprivate var emptyState: some View {
        VStack(spacing: 12) {
            Text("No data loaded")
                .font(AppFont.subTitle)

            Button("Reload") {
                Task { await viewModel.loadProducts() }
            }
        }
    }

    fileprivate var errorState: some View {
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
