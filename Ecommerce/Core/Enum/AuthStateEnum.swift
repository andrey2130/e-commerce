//
//  AuthStateEnum.swift
//  Ecommerce
//
//  Created by Andrii Duda on 29.01.2026.
//

enum AuthState: Equatable {
    case loading
    case authorized
    case unauthorized
    case error(Error)

    static func == (lhs: AuthState, rhs: AuthState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading),
            (.authorized, .authorized),
            (.unauthorized, .unauthorized):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}
