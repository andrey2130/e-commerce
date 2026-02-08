//
//  ChartState.swift
//  Ecommerce
//
//  Created by Andrii Duda on 08.02.2026.
//

enum CartState: Equatable {
    case loading
    case loaded
    case empty
    case error(Error)

    static func == (lhs: CartState, rhs: CartState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading),
            (.loaded, .loaded),
            (.empty, .empty):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}
