//
//  AuthError.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//

import SwiftUI

enum AuthValidationError: LocalizedError, Equatable {
    case emptyName
    case emptyEmail
    case invalidEmail
    case emptyPassword
    case shortPassword
    case passwordsDoNotMatch

    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Name is required"
        case .emptyEmail:
            return "Email is required"
        case .invalidEmail:
            return "Invalid email"
        case .emptyPassword:
            return "Password is required"
        case .shortPassword:
            return "Password must be at least 6 characters"
        case .passwordsDoNotMatch:
            return "Passwords do not match"
        }
    }
}
