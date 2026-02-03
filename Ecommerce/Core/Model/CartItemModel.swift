//
//  CartItemModel.swift
//  Ecommerce
//
//  Created by Andrii Duda on 03.02.2026.
//

import Foundation

struct CartItemModel: Codable, Identifiable {
    let id: Int
    let userId: Int
    let productId: Int
    let quantity: Int
    let product: CartProductSummary
}


struct CartProductSummary: Codable, Identifiable {
    let id: Int
    let name: String
    let price: String
}

struct CartListResponse: Codable {
    let success: Bool
    let count: Int
    let total: String
    let data: [CartListItem]
}

struct CartListItem: Codable, Identifiable {
    let id: Int
    let product: CartListItemProduct
    let quantity: Int
    let subtotal: Double
}

struct CartListItemProduct: Codable, Identifiable {
    let id: Int
    let name: String?
    let price: String
    let images: [String]?
    let category: Category?
}

struct MessageResponse: Codable {
    let success: Bool
    let message: String
}
