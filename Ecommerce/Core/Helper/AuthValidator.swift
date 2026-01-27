//
//  AuthValidator.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//

struct AuthValidator {

    static func validateLogin(
        email: String,
        password: String
    ) throws {
        if email.isEmpty {
            throw AuthValidationError.emptyEmail
        }
        if !email.contains("@") {
            throw AuthValidationError.invalidEmail
        }
        if password.isEmpty {
            throw AuthValidationError.emptyPassword
        }
        if password.count < 6 {
            throw AuthValidationError.shortPassword
        }
    }

    static func validateRegister(
        name: String,
        email: String,
        password: String,
        confirmPassword: String
    ) throws {
        if name.isEmpty {
            throw AuthValidationError.emptyName
        }
        try validateLogin(email: email, password: password)
        if password != confirmPassword {
            throw AuthValidationError.passwordsDoNotMatch
        }
    }
}
