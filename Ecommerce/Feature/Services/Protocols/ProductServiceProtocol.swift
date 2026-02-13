//
//  ProductServiceProtocol.swift
//  Ecommerce
//
//  Created by Andrii Duda on 02.02.2026.
//

protocol ProductServiceProtocol {
    func getProduct(page: Int, limit: Int) async throws -> ProductListModel
    func getProductById(_ id: Int) async throws -> ProductDetailsRequest
    func searchProduct(page: Int, limit: Int, search: String) async throws -> ProductListModel
}
