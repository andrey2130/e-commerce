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

    private init() {}

    func getProduct(page: Int, limit: Int = 10) async throws -> ProductListModel {
        let urlString = "\(AppiConts.getProductUrl)?page=\(page)&limit=\(limit)"

        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-type")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
            200...299 ~= httpResponse.statusCode
        else {
            throw NetworkError.invalidResponse
        }
        do {
            return try JSONDecoder().decode(ProductListModel.self, from: data)
        } catch {
            print("error decode product list: \(error)")
            throw NetworkError.decodingError
        }
    }
}
