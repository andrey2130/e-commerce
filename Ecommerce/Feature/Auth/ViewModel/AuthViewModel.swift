//
//  AuthViewModel.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//

import SwiftUI

@MainActor
@Observable
class AuthViewModel {
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var isLoading: Bool = false
    var validationError: AuthValidationError?
    var isRegistered: Bool = false

    var localStorageService: LocalStorageService = .shared

    private let authService = AuthService.shared

    func register() async {
        validationError = nil

        do {
            try AuthValidator.validateRegister(
                name: name,
                email: email,
                password: password,
                confirmPassword: confirmPassword
            )

            isLoading = true
            defer { isLoading = false }

            let response = try await authService.register(
                name: name,
                email: email,
                password: password
            )

            if let token = response.token {
                localStorageService.saveToken(token)
            }

            isRegistered = true
        } catch let error as AuthValidationError {
            validationError = error
        } catch {
            validationError = .invalidEmail  
        }
    }
}
