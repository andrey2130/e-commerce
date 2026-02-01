//
//  FavoritesView.swift
//  Ecommerce
//
//  Created by Andrii Duda on 31.01.2026.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(FavoritesViewModel.self) private var viewModel
    @Environment(Coordinator.self) private var coordinator
    @Environment(AuthViewModel.self) private var auth

    var body: some View {
        Group {

            switch viewModel.favoriteState {
            case .empty:
                emptyState
            case .loading:
                loadingState
            case .loaded:
                content
            case .error:
                ErrorState {}
            }
        }
        .task {
            await viewModel.loadFavorites()
        }
    }
}

// MARK: - Content

extension FavoritesView {

    private var content: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.favoritesProducts) { favorite in
                    FavoriteCard(
                        favorite: favorite,
                        onRemove: {

                            Task {
                                await viewModel.deleteFavorites(
                                    id: favorite.productId
                                )
                            }
                        },
                        onTap: {
                            coordinator.push(
                                .productDetails(id: favorite.productId)
                            )
                        }
                    )
                    .transition(
                        .asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        )
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemGroupedBackground))
    }

    private var loadingState: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)

            Text("Loading your favorites...")
                .font(AppFont.subTitle)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }

    private var emptyState: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.red.opacity(0.1),
                                Color.pink.opacity(0.05),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)

                Image(systemName: "heart.slash")
                    .font(.system(size: 48, weight: .light))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.red, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }

            VStack(spacing: 8) {
                Text("No Favorites Yet")
                    .font(AppFont.title)
                    .fontWeight(.bold)

                Text("Start adding products you love\nto your favorites list")
                    .font(AppFont.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 32)
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Favorite Card

struct FavoriteCard: View {
    let favorite: FavoriteListItem
    let onRemove: () -> Void
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: 16) {

            productImage

            VStack(alignment: .leading, spacing: 6) {
                Text(favorite.product.name)
                    .font(AppFont.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)

                if let category = favorite.product.category {
                    Text(category.name)
                        .font(AppFont.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.tertiarySystemGroupedBackground))
                        .clipShape(Capsule())
                }

                Spacer()

                Text("$\(favorite.product.price)")
                    .font(AppFont.title2)
                    .fontWeight(.bold)
            }

            removeButton
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }

    private var productImage: some View {
        Group {
            if let imageUrl = favorite.product.images?.first,
                let url = URL(string: imageUrl)
            {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color.gray.opacity(0.2)
                            ProgressView()
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        ZStack {
                            Color.gray.opacity(0.2)
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        }
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                ZStack {
                    Color.gray.opacity(0.2)
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(width: 100, height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var removeButton: some View {
        Button(action: onRemove) {
            ZStack {
                Circle()
                    .fill(Color(.tertiarySystemGroupedBackground))
                    .frame(width: 44, height: 44)

                Image(systemName: "heart.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.red, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        }
        .buttonStyle(.plain)
    }
}
