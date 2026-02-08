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

struct CartQuantityRequest: Encodable {
    let quantity: Int
}

struct CartResponse: Decodable {
    let success: Bool
    let data: CartItemModel
}

@Observable
final class CartService: CartServiceProtocol {
    
    

    private let api: ApiClient
    private(set) var cartProductIds: Set<Int> = []

    init(api: ApiClient) {
        self.api = api
    }

    func getCart(token: String) async throws -> [CartListItem] {
        var endpoint = Endpoint.get(ApiConst.cart)
        print("cart endpoint: \(endpoint)")
        endpoint.headers["Authorization"] = "Bearer \(token)"
        let response: CartListResponse = try await api.send(endpoint)
        cartProductIds = Set(response.data.map(\.product.id))
        print("cart response: \(response.data)")
        return response.data
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
        let _: MessageResponse = try await api.send(endpoint)
        cartProductIds.remove(productId)
    }

    func updateQuantity(cartItemId: Int, quantity: Int, token: String) async throws -> CartResponse {
        let path = "\(ApiConst.cart)/\(cartItemId)"
        let body = CartQuantityRequest(quantity: quantity)
        var endpoint = try Endpoint.put(path, body: body)
        endpoint.headers["Authorization"] = "Bearer \(token)"
        let response: CartResponse = try await api.send(endpoint)
        return response
        
    }
    
    func clearCart() {
        cartProductIds.removeAll()
    }

}
