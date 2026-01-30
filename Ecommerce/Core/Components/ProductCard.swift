//
//  ProductCard.swift
//  Ecommerce
//
//  Created by Andrii Duda on 29.01.2026.
//

import SwiftUI

struct ProductCard: View {
    let product: ProductModel
    var imageHeight: CGFloat = 180
    var cornerRadius: CGFloat = 12
    var onFavoriteToggle: (() -> Void)?
    var isFavorite: Bool = false
    var onTap: (() -> Void)
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            ProductImageView(
                imageURL: product.images.first,
                height: imageHeight,
                cornerRadius: cornerRadius,
                isFavorite: isFavorite,
                onFavoriteToggle: onFavoriteToggle
            )

            ProductInfoView(product: product)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - Product Image View
struct ProductImageView: View {
    let imageURL: String?
    var height: CGFloat = 180
    var cornerRadius: CGFloat = 12
    var isFavorite: Bool = false
    var onFavoriteToggle: (() -> Void)?

    var body: some View {
        imageContent
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .clipped()
            .cornerRadius(cornerRadius)
    }

    @ViewBuilder
    private var imageContent: some View {
        if let imageURL, let url = URL(string: imageURL) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .overlay(alignment: .topTrailing) {
                            FavoriteButton(
                                isFavorite: isFavorite,
                                action: onFavoriteToggle
                            )
                        }

                case .failure:
                    PlaceholderImageView()

                @unknown default:
                    PlaceholderImageView()
                }
            }
        } else {
            PlaceholderImageView()
        }
    }
}

// MARK: - Favorite Button
struct FavoriteButton: View {
    var isFavorite: Bool = false
    var action: (() -> Void)?

    var body: some View {
        Button {
            action?()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundStyle(.white)
                .shadow(
                    color: .black.opacity(0.3),
                    radius: 15,
                    x: 0,
                    y: 5
                )
                .padding(8)
                .background(Color.black.opacity(0.2))
                .clipShape(Circle())
                .shadow(
                    color: .black.opacity(0.2),
                    radius: 20,
                    x: 0,
                    y: 8
                )
        }
        .padding(8)
        .buttonStyle(.plain)
    }
}

// MARK: - Product Info View
struct ProductInfoView: View {
    let product: ProductModel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(product.name)
                .font(AppFont.subhead)
                .lineLimit(2)

            HStack {
                PriceView(price: product.price)
                Spacer()
                RatingView(
                    rating: product.rating,
                    reviewCount: product.reviewCount
                )
            }

            CategoryView(categoryName: product.category.name)
        }
    }
}

// MARK: - Price View
struct PriceView: View {
    let price: String

    var body: some View {
        Text("$\(price)")
            .font(AppFont.title3)
    }
}

// MARK: - Rating View
struct RatingView: View {
    let rating: String
    let reviewCount: Int

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: 12, height: 12)
                .foregroundStyle(.orange)

            Text(rating)
                .font(AppFont.caption)
                .foregroundStyle(.gray)

            Text("(\(reviewCount))")
                .font(AppFont.caption)
                .foregroundStyle(.gray)
        }
    }
}

// MARK: - Category View
struct CategoryView: View {
    let categoryName: String

    var body: some View {
        Text(categoryName)
            .font(AppFont.caption)
            .foregroundStyle(.gray)
    }
}

// MARK: - Placeholder Image View
struct PlaceholderImageView: View {
    var body: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.gray.opacity(0.5))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))
    }
}
