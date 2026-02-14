//
//  CategoryServiceProtocol.swift
//  Ecommerce
//
//  Created by Andrii Duda on 14.02.2026.
//

import Foundation

protocol CategoryServiceProtocol {
    func getCategories() async throws -> CategoryListModel
    func getCategoryById(_ id: Int) async throws -> CategoryDetailsModel
}
