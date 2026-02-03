//
//  ProductServiceProtocol.swift
//  Ecommerce
//
//  Created by Andrii Duda on 02.02.2026.
//

protocol ProductServiceProtocol {
    func getProduct(page: Int, limit: Int) async throws -> ProductListModel
    func getProductById(_ id: Int) async throws -> ProductDetailsRequest

}
