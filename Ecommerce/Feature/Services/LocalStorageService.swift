//
//  LocalStorageService.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//

import Foundation

final class LocalStorageService {
    static let shared = LocalStorageService()
    private let tokenKey = "token"
    private init() {}

    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }

    var isLoggedIn: Bool {
        UserDefaults.standard.string(forKey: tokenKey) != nil
    }

    func loguserOut() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }

}
