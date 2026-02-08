//
//  StoreKitManager.swift
//  Ecommerce
//

import Foundation
import StoreKit

@Observable
@MainActor
class StoreKitManager {
    var products: [StoreKit.Product] = []
    var isPurchasing = false
    var purchaseError: String?

    private let checkoutProductID = "com.ecommerce_test"

    init() {
        Task {
            await loadProducts()
        }
    }
    func loadProducts() async {

        do {
            products = try await StoreKit.Product.products(for: [
                checkoutProductID
            ])
        } catch {
            print("Failed to load products: \(error)")
            purchaseError = "Failed to load products"
        }
    }

    func purchase() async throws -> String? {
        guard let product = products.first else {
            throw StoreKitError.productNotFound
        }

        isPurchasing = true
        defer {
            isPurchasing = false

        }

        let result = try await product.purchase()

        switch result {
        case .success(let verification):

            let transaction = try checkVerified(verification)
            let transactionID = String(transaction.id)

            await transaction.finish()

            return transactionID

        case .userCancelled:

            throw StoreKitError.userCancelled

        case .pending:

            throw StoreKitError.pending

        @unknown default:
            throw StoreKitError.unknown
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreKitError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}

enum StoreKitError: LocalizedError {
    case productNotFound
    case failedVerification
    case userCancelled
    case pending
    case unknown

    var errorDescription: String? {
        switch self {
        case .productNotFound:
            return "Product not found"
        case .failedVerification:
            return "Verefication failed"
        case .userCancelled:
            return "Payment cancelled"
        case .pending:
            return "Payment pending"
        case .unknown:
            return "Unkwown error"
        }
    }
}
