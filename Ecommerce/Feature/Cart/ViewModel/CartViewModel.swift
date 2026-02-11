//
//  CartViewModel.swift
//  Ecommerce
//
//  Created by Andrii Duda on 03.02.2026.
//

import Factory
import Foundation

@Observable
@MainActor
final class CartViewModel {

    @ObservationIgnored
    @Injected(\.cartService)
    private var cartService

    @ObservationIgnored
    @Injected(\.localStorageService)
    private var localStorage

    private(set) var cartProducts: [CartListItem] = []
    var cartState: CartState = .loading
    var quantityError: String? = nil

    private var token: String? {
        guard let token = localStorage.getToken(), !token.isEmpty else {
            return nil
        }
        return token
    }

    var totalPrice: Double {
        cartProducts.reduce(0) { total, item in
            total + Double(item.quantity) * (Double(item.product.price) ?? 0)
        }
    }

    func isInCart(productId: Int) -> Bool {
        cartService.cartProductIds.contains(productId)
    }

    func preloadCartIfNeeded() async {
        guard let token, cartService.cartProductIds.isEmpty else { return }
        await fetchCart(token: token, silent: true)
    }

    func loadCart() async {
        guard let token else { return }
        await fetchCart(token: token)
    }

    func addToCart(productId: Int, count: Int = 1) async {
        guard let token else { return }

        do {
            _ = try await cartService.addProductToCart(
                productId: productId,
                count: count,
                token: token
            )
            await loadCart()
        } catch {
            handle(error)
        }
    }

    func increaseQuantity(cartItemId: Int) async {
        await updateQuantity(cartItemId: cartItemId, delta: +1)
    }

    func decreaseQuantity(cartItemId: Int) async {
        await updateQuantity(cartItemId: cartItemId, delta: -1)
    }
    


    func removeFromCart(productId: Int) async {
        guard let token else { return }

        guard
            let item = cartProducts.first(where: { $0.product.id == productId })
        else {
            return
        }

        do {
            try await cartService.removeFromCart(
                cartItemId: item.id,
                productId: productId,
                token: token
            )
            await loadCart()
        } catch {
            handle(error)
        }
    }

    private func fetchCart(token: String, silent: Bool = false) async {
        do {
            cartProducts = try await cartService.getCart(token: token)
            cartState = cartProducts.isEmpty ? .empty : .loaded
        } catch {
            if !silent {
                handle(error)
            }
        }
    }

    private func updateQuantity(cartItemId: Int, delta: Int) async {
        guard let token else { return }
        guard let current = cartProducts.first(where: { $0.id == cartItemId })
        else {
            return
        }
        let avaibleStock = current.product.stock
        let newQuantity = current.quantity + delta

        if newQuantity <= 0 {
            await removeFromCart(productId: current.product.id)
            return
        }
        
        if newQuantity > avaibleStock {
            return quantityError = "Only \(avaibleStock) left in stock."
            
        }
        quantityError = nil

        do {
            _ = try await cartService.updateQuantity(
                cartItemId: cartItemId,
                quantity: newQuantity,
                token: token
            )
            await loadCart()
        } catch {
            await loadCart()
        }
    }

    private func handle(_ error: Error) {
        cartState = .error(error)
        print("Cart error:", error.localizedDescription)
    }
}
