//
//  ApiClientProtocol.swift
//  Ecommerce
//
//  Created by Andrii Duda on 02.02.2026.
//

protocol ApiClientProtocol {
    func send<T: Decodable>(_ endpoit: Endpoint) async throws -> T
}
