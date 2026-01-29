//
//  AuthStateEnum.swift
//  Ecommerce
//
//  Created by Andrii Duda on 29.01.2026.
//

enum AuthState {
    case loading
    case authorized
    case unauthorized
    case error(Error)
}
