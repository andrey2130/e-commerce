//
//  PaymentViewModel.swift
//  Ecommerce
//
//  Created by Andrii Duda on 08.02.2026.
//

import Factory
import Foundation

@Observable
@MainActor
class PaymentViewModel {
    @ObservationIgnored @Injected(\.orderService) private var orderService
    @ObservationIgnored @Injected(\.orderManager) private var storeKitManager
    @ObservationIgnored @Injected(\.localStorageService) private
        var localStorage

    private var token: String? {
        guard let token = localStorage.getToken(), !token.isEmpty else {
            return nil
        }
        return token
    }

    var isProcessing = false
    var orderCompleted = false
    var errorMessage: String?
    var orderData: OrderData?

    func processCheckout(shippingAddress: String) async {

        isProcessing = true
        errorMessage = nil

        do {
            guard let token else {
                throw CheckoutError.unauthorized
            }

            if storeKitManager.products.isEmpty {
                await storeKitManager.loadProducts()
            }

            else {
                throw CheckoutError.paymentFailed
            }

            let response = try await orderService.createOrder(
                token: token,
                shippingAddress: shippingAddress,
                paymentMethod: "ApplePay"
            )
            if response.success {
                orderData = response.data
                orderCompleted = true
            } else {
                throw CheckoutError.orderCreationFailed
            }

        } catch let error as StoreKitError {

            errorMessage = error.localizedDescription
        } catch let error as CheckoutError {

            errorMessage = error.localizedDescription
        } catch {

            errorMessage = "Error: \(error.localizedDescription)"
        }

        isProcessing = false
    }
}

extension PaymentViewModel {
    enum CheckoutError: LocalizedError {
        case unauthorized
        case paymentFailed
        case orderCreationFailed

        var errorDescription: String? {
            switch self {
            case .unauthorized:
                return "Login required"
            case .paymentFailed:
                return "Payment error"
            case .orderCreationFailed:
                return "Order creation error"
            }
        }
    }
}
