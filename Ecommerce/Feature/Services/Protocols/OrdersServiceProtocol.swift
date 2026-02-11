//
//  OrdersServiceProtocol.swift
//  Ecommerce
//
//  Created by Andrii Duda on 08.02.2026.
//

protocol OrdersServiceProtocol {
    func createOrder(
        token: String,
        shippingAddress: String,
        paymentMethod: String
    ) async throws -> CreateOrderResponse
    func getOrder(token: String) async throws -> OrderResponse
}
