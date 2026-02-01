//
//  Pagination.swift
//  Ecommerce
//
//  Created by Andrii Duda on 30.01.2026.
//
import SwiftUI

@Observable
class Pagination {
    var page = 1
    var canLoadMore = true
    var isLoadingMore: Bool = false

    func nextPage() {
        page += 1
    }

    func stop() {
        canLoadMore = false
    }
}
