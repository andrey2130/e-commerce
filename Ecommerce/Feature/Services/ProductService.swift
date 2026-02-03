//
//  ProductService.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//

import Foundation
import SwiftUI

struct ProductDetailsRequest: Decodable {
    let success: Bool
    let data: ProductModel
}

final class ProductService: ProductServiceProtocol {
    private let api: ApiClient

    init(api: ApiClient) {
        self.api = api
    }
    
    func getProduct(page: Int, limit: Int = 10) async throws -> ProductListModel
    {
        let query = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
        ]
        let endpoint = Endpoint.get("\(ApiConst.getProductUrl)", query: query)
        print("Endpoint body \(endpoint.query)")
        return try await api.send(endpoint)
    }

    func getProductById(_ id: Int) async throws -> ProductDetailsRequest {
        let endpoint = Endpoint.get("\(ApiConst.getProductById)/\(id)")
        print("\(endpoint)")
        return try await api.send(endpoint)
    }

}
