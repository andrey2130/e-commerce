//
//  AuthViewModel.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//

import Factory
import Foundation
import SwiftUI

@MainActor
@Observable
class AuthViewModel {
    @ObservationIgnored @Injected(\.authService) private var authService
    @ObservationIgnored @Injected(\.localStorageService) private var localStorageService
    @ObservationIgnored @Injected(\.favoritesService) private var favoriteService
    
    

    var name: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var isLoading: Bool = false
    var validationError: AuthValidationError?
    var state: AuthState = .unauthorized

    init() {
        checkAuthState()
    }
    
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
                state = .authorized
            }

        } catch let error as AuthValidationError {
            validationError = error
        } catch {
            validationError = .invalidEmail
        }
    }

    func login() async {
        validationError = nil

        do {
            try AuthValidator.validateLogin(email: email, password: password)
            isLoading = true
            defer { isLoading = false }
            let responce = try await authService.login(
                email: email,
                password: password
            )
            if let token = responce.token {
                localStorageService.saveToken(token)
                state = .authorized
            }

        } catch let error as AuthValidationError {
            validationError = error
        } catch {
            validationError = .invalidEmail
        }
    }
    
    func checkAuthState() {
        if let token = localStorageService.getToken(), !token.isEmpty {
            state = .authorized
        } else {
            state = .unauthorized
        }
    }

    func logout() {
        localStorageService.loguserOut()
        favoriteService.clearFavorites()
        state = .unauthorized
    }
}
