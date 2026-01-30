//
//  ProductService.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//

import Foundation
import SwiftUI

struct ProductDetailsReques: Decodable {
    let success: Bool
    let data: ProductModel
}

final class ProductService {
    static let shared = ProductService()
    private let api = ApiClient(baseURL: URL(string: AppiConts.baseUrl)!)

    private init() {}

    func getProduct(page: Int, limit: Int = 10) async throws -> ProductListModel
    {
        let query = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
        ]
        let endpoint = Endpoint.get("\(AppiConts.getProductUrl)", query: query)
     
        print("Endpoint body \(endpoint.query)")
        return try await api.send(endpoint)
    }

    func getProductById(_ id: Int) async throws -> ProductDetailsReques {
        let endpoint = Endpoint.get("\(AppiConts.getProductById)/\(id)")
        print("\(endpoint)")
        
        return try await api.send(endpoint)
    }
}
