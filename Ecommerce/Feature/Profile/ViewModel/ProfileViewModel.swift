//
//  ProfileViewModel.swift
//  Ecommerce
//
//  Created by Andrii Duda on 29.01.2026.
//

import SwiftUI

@Observable
@MainActor
final class ProfileViewModel {
    private let profileService: ProfileService = .shared
    private let localStorage: LocalStorageService = .shared

    var authState: AuthState = .loading
    var user: UserModel? = nil

    func getUser() async {

        guard let token = localStorage.getToken(), !token.isEmpty else {
            user = nil
            authState = .unauthorized
            return
        }

        authState = .loading

        do {
            let fetchedUser = try await profileService.getUserData(token: token)
            user = fetchedUser
            authState = .authorized
        } catch {

            user = nil
            authState = .unauthorized
        }
    }
}
