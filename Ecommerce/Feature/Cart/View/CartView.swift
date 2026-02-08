//
//  CartView.swift
//  Ecommerce
//
//  Created by Andrii Duda on 03.02.2026.
//

import SwiftUI

struct CartView: View {
    @State private var viewModel = CartViewModel()

    var body: some View {
        VStack {
            switch viewModel.cartState {
            case .loading:
                ProgressView()
            case .loaded:
                cartContentView
            case .empty:
                emptyCartView
            case .error(_):
                ErrorState {
                    Task {
                        await viewModel.loadCart()
                    }
                }
            }
        }
        .task {
            await viewModel.loadCart()
        }
    }

    // MARK: - Empty State

    private var emptyCartView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                Spacer(minLength: 80)

                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.blue.opacity(0.1),
                                    Color.purple.opacity(0.05),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 140, height: 140)

                    Image(systemName: "cart")
                        .font(.system(size: 60, weight: .regular))
                        .foregroundStyle(.secondary.opacity(0.6))
                }

                VStack(spacing: 8) {
                    Text("Your cart is empty")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)

                    Text("Add items to get started")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 80)
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Cart Content

    private var cartContentView: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    headerSection
                    VStack(spacing: 12) {
                        ForEach(viewModel.cartProducts, id: \.id) { item in
                            VStack(alignment: .trailing) {
                                CartItemRow(
                                    item: item,
                                    onIncrease: {
                                        Task {
                                            await viewModel.increaseQuantity(
                                                cartItemId: item.id
                                            )
                                        }
                                    },
                                    onDecrease: {
                                        Task {
                                            await viewModel.decreaseQuantity(
                                                cartItemId: item.id
                                            )
                                        }
                                    },
                                    onRemove: {
                                        Task {
                                            await viewModel.removeFromCart(
                                                productId: item.product.id
                                            )
                                        }
                                    }

                                )
                                if viewModel.quantityError != nil {
                                    Text(viewModel.quantityError!)
                                        .font(AppFont.caption)
                                }
                            }

                        }

                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 120)
            }

            checkoutBar
        }

    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("My Cart")
                    .font(AppFont.body)

                Spacer()

                Text("\(viewModel.cartProducts.count) items")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }

    // MARK: - Checkout Bar

    private var checkoutBar: some View {

        VStack(alignment: .leading, spacing: 4) {
            Text("Total")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("$\(viewModel.totalPrice,  specifier: "%.2f")")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            CustomButton(title: "Checkout") {

            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Cart Item Row

struct CartItemRow: View {
    let item: CartListItem
    let onIncrease: () -> Void
    let onDecrease: () -> Void
    let onRemove: () -> Void

    @State private var showDeleteConfirmation = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                // Product Image
                AsyncImage(
                    url: URL(string: item.product.images?.first ?? "")
                ) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color(.systemGray6))
                            .overlay {
                                ProgressView()
                            }
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Rectangle()
                            .fill(Color(.systemGray6))
                            .overlay {
                                Image(systemName: "photo")
                                    .foregroundStyle(.secondary)
                                    .font(.system(size: 24))
                            }
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 80, height: 80)
                .clipShape(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                )

                // Product Details
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.product.name ?? "")
                        .font(.system(size: 15, weight: .semibold))
                        .lineLimit(2)
                        .foregroundStyle(.primary)

                    if let category = item.product.category {
                        Text("\(category.name)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    HStack {
                        Text(
                            "$\(Double(item.product.price) ?? 0.0, specifier: "%.2f")"
                        )
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.primary)

                        Spacer()
                    }
                }

                Spacer()

                // Delete Button
                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
            }
            .padding(14)

            Divider()
                .padding(.leading, 106)

            // Quantity Controls
            HStack(spacing: 12) {
                Text("Quantity")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)

                Spacer()

                HStack(spacing: 16) {
                    Button(action: onDecrease) {
                        Image(systemName: "minus")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(width: 32, height: 32)
                            .background(Color(.systemBackground))
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 10,
                                    style: .continuous
                                )
                            )
                    }
                    .buttonStyle(.plain)

                    Text("\(item.quantity)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.primary)
                        .frame(minWidth: 24)

                    Button(action: onIncrease) {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(width: 32, height: 32)
                            .background(Color(.systemBackground))
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 10,
                                    style: .continuous
                                )
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(14)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .confirmationDialog(
            "Remove item from cart?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Remove", role: .destructive) {
                onRemove()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

#Preview {
    CartView()
}
