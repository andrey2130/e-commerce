//
//  ProductModel.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//


import SwiftUI

struct ProductListModel: Codable {
    let count: Int
    let page: Int
    let pages: Int
    let data: [ProductModel]
}


struct ProductModel: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let price: String
    let stock: Int
    let images: [String]
    let categoryId: Int
    let isActive: Bool
    let rating: String
    let reviewCount: Int
    let createdAt: String
    let updatedAt: String
    let category: Category
}


struct Category: Codable {
    let id: Int
    let name: String
}
