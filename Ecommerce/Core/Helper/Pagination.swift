//
//  Pagination.swift
//  Ecommerce
//
//  Created by Andrii Duda on 30.01.2026.
//


struct Pagination {
    var page = 1
    var canLoadMore = true

    mutating func nextPage() {
        page += 1
    }

    mutating func stop() {
        canLoadMore = false
    }
}