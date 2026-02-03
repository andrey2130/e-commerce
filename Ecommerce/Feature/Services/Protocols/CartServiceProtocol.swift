//
//  CartServiceProtocol.swift
//  Ecommerce
//
//  Created by Andrii Duda on 03.02.2026.
//

protocol CartServiceProtocol {
    var cartProductIds: Set<Int> { get }
    func getCart(token: String) async throws -> CartListResponse
    func addProductToCart(productId: Int, count: Int, token: String)
        async throws -> CartResponse
    func removeFromCart(cartItemId: Int, productId: Int, token: String) async throws
    func clearCart()
}
