//
//  ProductListView.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//

import Factory
import SwiftUI

struct ProductListView: View {
    @State private var viewModel = Container.shared.productViewModel()
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

            case .loaded:
                content(products: viewModel.displayedProducts)

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
                await viewModel.loadCategories()
                await viewModel.loadProducts()
            }
        }
    }
}

// MARK: - Content

extension ProductListView {

    fileprivate func content(products: [ProductModel]) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header
                categoryFilter
                grid(products: products)

                if currentPaginationState.isLoadingMore {
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
        VStack(alignment: .leading, spacing: 16) {
            Text("Discover")
                .font(AppFont.largeTitle)

            Text("Find your perfect items")
                .font(AppFont.subTitle)
                .foregroundStyle(.gray)

            
            HStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                        .font(.system(size: 16))

                    TextField("Search products", text: $viewModel.searchText)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                    if !viewModel.searchText.isEmpty {
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.searchText = ""
                                viewModel.searchResults.removeAll()
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.gray)
                                .font(.system(size: 16))
                        }
                        .buttonStyle(.plain)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            Color(.systemGray4).opacity(0.3),
                            lineWidth: 0.5
                        )
                )
            }
            .animation(
                .easeInOut(duration: 0.2),
                value: viewModel.searchText.isEmpty
            )
            .onChange(of: viewModel.searchText) { _, newValue in
                Task {
                    if newValue.isEmpty {
                        viewModel.searchResults.removeAll()
                        viewModel.searchPagination.reset()
                    } else {
                        await viewModel.searchProducts(reset: true)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 8)
    }

    fileprivate var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {

                CategoryChip(
                    title: "All",
                    isSelected: viewModel.selectedCategory == nil
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.filterByCategory(nil)
                    }
                }

                ForEach(viewModel.categories) { category in
                    CategoryChip(
                        title: category.name,
                        count: category.productCount,
                        isSelected: viewModel.selectedCategory == category.id
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.filterByCategory(category.id)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 12)
    }

    fileprivate func grid(products: [ProductModel]) -> some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(products) { product in
                ProductCard(
                    product: product,
                    onFavoriteToggle: {
                        handleFavoriteTap(product)
                    },
                    isFavorite: favoriteViewModel.isFavorite(product.id)
                ) {
                    coordinator.push(.productDetails(id: product.id))
                }
                .task {
                    if viewModel.isSearching {
                        await viewModel.loadMoreSearchIfNeeded(
                            currentItem: product
                        )
                    } else {
                        await viewModel.loadMoreIfNeeded(currentItem: product)
                    }
                }
            }
            .padding(.top, 16)
        }
    }

    private func handleFavoriteTap(_ product: ProductModel) {
        if auth.state == .unauthorized {
            print(auth.state)
            showAuthAlert = true
            print(showAuthAlert)
            return
        }

        Task {
            if favoriteViewModel.isFavorite(product.id) {
                await favoriteViewModel.deleteFavorites(id: product.id)
            } else {
                await favoriteViewModel.setAsFavorites(id: product.id)
            }
        }
    }

    private var currentPaginationState: Pagination {
        viewModel.isSearching
            ? viewModel.searchPagination : viewModel.pagination
    }
}

// MARK: - Category Chip Component

struct CategoryChip: View {
    let title: String
    var count: Int? = nil
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(title)
                    .font(
                        .system(
                            size: 14,
                            weight: isSelected ? .semibold : .regular
                        )
                    )

                if let count = count {
                    Text("(\(count))")
                        .font(.system(size: 12))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.black : Color(.systemGray6))
            .foregroundColor(isSelected ? .white : .black)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isSelected
                            ? Color.clear : Color(.systemGray4).opacity(0.3),
                        lineWidth: 0.5
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - States

extension ProductListView {

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
    ProductListView()
}
