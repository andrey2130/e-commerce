//
//  LocalStorageProtocol.swift
//  Ecommerce
//
//  Created by Andrii Duda on 02.02.2026.
//

protocol LocalStorageProtocol {
    var isLoggedIn: Bool { get }
    var isOnboardingCompleted: Bool { get }
    func saveToken(_ token: String)
    func getToken() -> String?
    func loguserOut()
    func markOnboardingAsComnpeted()
}
