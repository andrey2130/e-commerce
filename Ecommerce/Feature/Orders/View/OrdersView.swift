//
//  OrdersView.swift
//  Ecommerce
//
//  Created by Andrii Duda on 08.02.2026.
//

import SwiftUI

struct OrdersView: View {
    @Environment(Coordinator.self) private var coordinator
    @State private var viewModel = OrdersViewModel()

    var body: some View {
        Group {
            switch viewModel.orderState {

            case .loading:
                VStack(spacing: 12) {
                    ProgressView()
                    Text("Loading your orders...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 80)

            case .empty:
                VStack(spacing: 12) {
                    Image(systemName: "bag")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)

                    Text("No orders yet")
                        .font(.headline)

                    Text("Once you place an order, it’ll appear here.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 80)

            case .error:
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.red)

                    Text("Something went wrong")
                        .font(.headline)
                }
                .padding(.top, 80)

            case .loaded(let orders):
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(orders, id: \.id) { order in
                            OrderCardView(order: order)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("My Orders")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            Task {
                try await viewModel.getOrders()
            }
        }
    }
}
