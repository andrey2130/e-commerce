//
//  OrdersViewModel.swift
//  Ecommerce
//
//  Created by Andrii Duda on 08.02.2026.
//

import Factory
import Foundation

enum OrderState {
    case loading
    case empty
    case loaded([OrderData])
    case error(Error)

}

@Observable
@MainActor
final class OrdersViewModel {
    @ObservationIgnored @Injected(\.orderService) private var orderService
    @ObservationIgnored @Injected(\.localStorageService) private
        var localStorage

    var orders: [OrderData] = []
    var orderState: OrderState = .loading
    private var token: String? {
        guard let token = localStorage.getToken(), !token.isEmpty else {
            return nil
        }
        return token
    }

    func getOrders() async throws {
        guard let token else { return }

        do {
            let response = try await orderService.getOrder(token: token)
            let orders = response.data
            self.orders = orders

            orderState = orders.isEmpty ? .empty : .loaded(orders)
        } catch {
            orderState = .error(error)
        }
    }

}
