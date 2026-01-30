//
//  ContentLoadingStateEnum.swift
//  Ecommerce
//
//  Created by Andrii Duda on 29.01.2026.
//


enum ContentLoadingState {
    case loading
    case completed
    case empty
    case error(Error)
}


enum DetailsLoadingState: Equatable {
    case loading
    case completed
    case empty
    case error(Error)

    static func == (lhs: DetailsLoadingState, rhs: DetailsLoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading),
             (.completed, .completed),
             (.empty, .empty):
            return true
        case (.error, .error):
            return true // ignoring error value
        default:
            return false
        }
    }
}
