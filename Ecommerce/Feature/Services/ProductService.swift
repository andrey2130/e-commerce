//
//  ProductService.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//

import Foundation
import SwiftUI

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
        print(query)
        let endpoint = Endpoint.get("\(AppiConts.getProductUrl)", query: query)
        print(endpoint)
        print("Endpoint body \(endpoint.query)")
        return try await api.send(endpoint)
    }
}
