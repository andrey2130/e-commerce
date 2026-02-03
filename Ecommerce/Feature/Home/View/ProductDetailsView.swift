//
//  ProductDetailsView.swift
//  Ecommerce
//
//  Created by Andrii Duda on 29.01.2026.
//

import Factory
import SwiftUI

struct ProductDetailsView: View {

    let productId: Int
    @State private var viewModel = Container.shared.productViewModel()

    @State private var showAuthAlert: Bool = false
    @Environment(FavoritesViewModel.self) private var favoritesViewModel
    @Environment(AuthViewModel.self) private var auth
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        VStack {
            switch viewModel.productDetailsState {

            case .idle, .loading:
                ProgressView()

            case .loaded(let product):
                content(product: product)

            case .empty:
                Text("No data")

            case .error(let error):
                Text(error.localizedDescription)
            }
        }
        .alert("Login required", isPresented: $showAuthAlert) {
            Button("Loggin") {
                coordinator.push(.login)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("You need to be logged in to add products to favorites.")
        }
        .ignoresSafeArea()
        .task {
            if case .idle = viewModel.productDetailsState {
                await viewModel.loadProductDetails(id: productId)
            }
        }
    }

    private func createProductDeepLink(productId: Int) -> URL {
        URL(string: "ecommerce://product/\(productId)")!
    }
}

// MARK: - Content

extension ProductDetailsView {

    fileprivate func content(product: ProductModel) -> some View {
        ScrollView {
            VStack(spacing: 0) {

                ProductImagesView(images: product.images)

                VStack(alignment: .leading, spacing: 16) {

                    ProductHeaderView(product: product)

                    Divider()

                    ProductPriceView(price: product.price)

                    Divider()

                    ProductDescriptionView(
                        description: product.description
                    )

                    ProductActionsView(
                        product: product,
                        isFavorite: favoritesViewModel.isFavorite(product.id),
                        
                        onFavoriteTap: {
                            handleFavoriteTap(product)

                        },
                        viewModel: viewModel
                    )
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if let product = viewModel.selectedProduct {
                    ShareLink(
                        item: createProductDeepLink(productId: product.id),
                        subject: Text(product.name),
                    ) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }

    private func handleFavoriteTap(_ product: ProductModel) {
        if auth.state == .unauthorized {
            showAuthAlert = true
            return
        }

        Task {
            if favoritesViewModel.isFavorite(product.id) {
                await favoritesViewModel.deleteFavorites(id: product.id)
            } else {
                await favoritesViewModel.setAsFavorites(id: product.id)
            }
        }
    }
}

// MARK: - Subviews

private struct ProductImagesView: View {
    let images: [String]

    var body: some View {
        TabView {
            ForEach(images, id: \.self) { imageUrl in
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(ProgressView())
                }
            }
        }
        .frame(height: 400)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

private struct ProductHeaderView: View {
    let product: ProductModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Category: \(product.category.name)")
                .font(AppFont.bodyMedium)
                .foregroundStyle(.gray)

            Text(product.name)
                .font(AppFont.title2)

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)

                Text(product.rating)
                    .font(AppFont.bodyBold)

                Text("(\(product.reviewCount) reviews)")
                    .foregroundStyle(.gray)
            }
        }
        .padding(.horizontal)
        .padding(.vertical)
    }

}

private struct ProductPriceView: View {
    let price: String

    var body: some View {
        Text("$\(price)")
            .font(AppFont.title)
            .padding(.horizontal)
    }

}

private struct ProductDescriptionView: View {
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(AppFont.headline)

            Text(description)
                .font(AppFont.subheadline)
                .foregroundStyle(.gray)
        }
        .padding(.horizontal)
    }
}

private struct ProductActionsView: View {
    let product: ProductModel
    let isFavorite: Bool
    let onFavoriteTap: () -> Void
    let viewModel: ProductViewModel

    var body: some View {
        HStack(spacing: 12) {
            Button {
                onFavoriteTap()
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundStyle(isFavorite ? .red : .black)
                    .frame(width: 50, height: 50)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            CustomButton(title: viewModel.inCart ? "Remove from Cart" : "Add to Cart") {
                Task {
                   await viewModel.addToCart(productId: product.id)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ProductDetailsView(productId: 9)
}
