//
//  CartService.swift
//  Ecommerce
//
//  Created by Andrii Duda on 03.02.2026.
//

import Foundation

struct CartRequest: Encodable {
    let productId: Int
    let quantity: Int
}

struct CartResponse: Decodable {
    let success: Bool
    let data: CartItemModel
}

final class CartService: CartServiceProtocol {

    private let api: ApiClient
    private(set) var cartProductIds: Set<Int> = []

    init(api: ApiClient) {
        self.api = api
    }

    func getCart(token: String) async throws -> CartListResponse {
        var endpoint = Endpoint.get(ApiConst.cart)
        endpoint.headers["Authorization"] = "Bearer \(token)"
        let response: CartListResponse = try await api.send(endpoint)
        cartProductIds = Set(response.data.map { $0.product.id })
        return response
    }

    func addProductToCart(productId: Int, count: Int = 1, token: String)
        async throws
        -> CartResponse
    {
        let body = CartRequest(productId: productId, quantity: count)
        var endpoint = try Endpoint.post(ApiConst.cart, body: body)
        endpoint.headers["Authorization"] = "Bearer \(token)"
        let response: CartResponse = try await api.send(endpoint)
        cartProductIds.insert(productId)
        return response
    }

    func removeFromCart(cartItemId: Int, productId: Int, token: String)
        async throws
    {
        let path = "\(ApiConst.cart)/\(cartItemId)"
        var endpoint = Endpoint.delete(path)
        endpoint.headers["Authorization"] = "Bearer \(token)"
        let _: CartResponse = try await api.send(endpoint)
        cartProductIds.remove(productId)
    }

    func clearCart() {
        cartProductIds.removeAll()
    }

}
