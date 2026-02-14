//
//  CategoryService.swift
//  Ecommerce
//
//  Created by Andrii Duda on 14.02.2026.
//

import Foundation

final class CategoryService: CategoryServiceProtocol {
    private let api: ApiClient

    init(api: ApiClient) {
        self.api = api
    }

    func getCategories() async throws -> CategoryListModel {
        let endpoint = Endpoint.get(ApiConst.categories)
        return try await api.send(endpoint)
    }

    func getCategoryById(_ id: Int) async throws -> CategoryDetailsModel {
        let endpoint = Endpoint.get("\(ApiConst.categories)/\(id)")
        return try await api.send(endpoint)
    }
}
