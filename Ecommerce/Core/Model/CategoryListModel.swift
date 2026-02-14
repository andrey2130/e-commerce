//
//  CategoryListModel.swift
//  Ecommerce
//
//  Created by Andrii Duda on 14.02.2026.
//


import Foundation

struct CategoryListModel: Codable {
    let success: Bool
    let count: Int
    let data: [CategoryModel]
}

struct CategoryModel: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let image: String?
    let isActive: Bool
    let productCount: Int?
    let createdAt: String?
    let updatedAt: String?
}

struct CategoryDetailsModel: Codable {
    let success: Bool
    let data: CategoryDetail
}

struct CategoryDetail: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let image: String?
    let products: [ProductModel]?
}
