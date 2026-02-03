//
//  LocalStorageService.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//

import Foundation

final class LocalStorageService: LocalStorageProtocol {
    private let tokenKey = "token"
    private let onboardingKey = "onboarding"

    var isLoggedIn: Bool {
        UserDefaults.standard.string(forKey: tokenKey) != nil
    }

    var isOnboardingCompleted: Bool {
        UserDefaults.standard.string(forKey: onboardingKey) != nil
    }

    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    func getToken() -> String? {
        UserDefaults.standard.string(forKey: tokenKey)
    }

    func loguserOut() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }

    func markOnboardingAsComnpeted() {
        UserDefaults.standard.set(true, forKey: onboardingKey)
    }
}
