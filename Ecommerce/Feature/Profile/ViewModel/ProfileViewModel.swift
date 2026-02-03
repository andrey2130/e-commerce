//
//  ProfileViewModel.swift
//  Ecommerce
//
//  Created by Andrii Duda on 29.01.2026.
//

import Factory
import SwiftUI

@Observable
@MainActor
final class ProfileViewModel {
    @ObservationIgnored @Injected(\.profileService) private var profileService
    @ObservationIgnored @Injected(\.localStorageService) private
        var localStorage

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
    func setUnAuthorized() {
        user = nil
        authState = .unauthorized
    }
}
