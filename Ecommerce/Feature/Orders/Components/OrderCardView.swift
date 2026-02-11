//
//  OrderCardView.swift
//  Ecommerce
//
//  Created by Andrii Duda on 08.02.2026.
//

import SwiftUI

struct OrderCardView: View {
    @Environment(Coordinator.self) private var coordinator
    let order: OrderData

    private var previewImages: [String] {
        order.orderItems
            .compactMap { $0.product.images?.first }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                StatusBadge(status: order.status)

                Spacer()

                Text(order.createdAtFormatted)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text("Order #\(order.orderNumber)")
                .font(.headline)
                .lineLimit(1)

            HStack(alignment: .center, spacing: 16) {

                Button {
                    guard let productId = order.orderItems.first?.product.id
                    else { return }
                    coordinator.push(.productDetails(id: productId))

                } label: {
                    ZStack {
                        ForEach(
                            Array(previewImages.prefix(3).enumerated()),
                            id: \.offset
                        ) { index, img in
                            AsyncImage(url: URL(string: img)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.gray.opacity(0.15)
                            }
                            .frame(width: 48, height: 48)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        Color(.systemBackground),
                                        lineWidth: 2
                                    )
                            )
                            .offset(x: CGFloat(index) * 18)
                        }

                        if order.orderItems.count > 3 {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.secondarySystemBackground))

                                Text("+\(order.orderItems.count - 3)")
                                    .font(.caption.bold())
                                    .foregroundStyle(.secondary)
                            }
                            .frame(width: 48, height: 48)
                            .offset(x: CGFloat(3) * 18)
                        }
                    }
                }
                .buttonStyle(.plain)  // 👈 важливо, щоб не було синього highlight
                .frame(
                    width: 48 + CGFloat(min(order.orderItems.count, 4) - 1) * 18
                )

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("Total")
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    Text("$\(order.totalAmount)")
                        .font(.title2.bold())
                }
            }

            // MARK: Bottom Metadata
            HStack(spacing: 12) {
                Label(
                    order.paymentStatus.capitalized,
                    systemImage: "creditcard"
                )
                .font(.caption)
                .foregroundStyle(.secondary)

                Text("•")

                Text(order.paymentMethod)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 16, y: 8)
        )
        .contentShape(RoundedRectangle(cornerRadius: 24))
    }
}
