//
//  DIContainer.swift
//  Ecommerce
//
//  Created by Andrii Duda on 02.02.2026.
//

import Factory
import Foundation

extension Container {

    // MARK: - Infrastructure Layer

    var baseURL: Factory<URL> {
        self {
            guard let url = URL(string: ApiConst.baseUrl) else {
                fatalError("Invalid base URL: \(ApiConst.baseUrl)")
            }
            return url
        }
        .singleton
    }

    var urlSession: Factory<URLSession> {
        self { .shared }
            .singleton
    }

    var apiClient: Factory<ApiClient> {
        self {
            ApiClient(
                baseURL: self.baseURL(),
                session: self.urlSession()
            )
        }
        .singleton
    }

    // MARK: - Services Layer

    var localStorageService: Factory<LocalStorageProtocol> {
        self { LocalStorageService() }
            .singleton
    }

    var authService: Factory<AuthServiceProtocol> {
        self { AuthService(api: self.apiClient()) }
            .singleton
    }

    var productService: Factory<ProductServiceProtocol> {
        self { ProductService(api: self.apiClient()) }
            .singleton
    }

    var profileService: Factory<ProfileServiceProtocol> {
        self { ProfileService(api: self.apiClient()) }
            .singleton
    }

    var favoritesService: Factory<FavoritesServiceProtocol> {
        self { FavoritesService(api: self.apiClient()) }
            .singleton
    }

    var cartService: Factory<CartServiceProtocol> {
        self { CartService(api: self.apiClient()) }
            .singleton
    }

    // MARK: - ViewModels Layer

    var authViewModel: Factory<AuthViewModel> {
        self { @MainActor in
            AuthViewModel()
        }
        .singleton
    }

    var favoritesViewModel: Factory<FavoritesViewModel> {
        self { @MainActor in
            FavoritesViewModel()
        }
        .singleton
    }

    var productViewModel: Factory<ProductViewModel> {
        self { @MainActor in
            ProductViewModel()
        }
        .unique
    }

    var profileViewModel: Factory<ProfileViewModel> {
        self { @MainActor in
            ProfileViewModel()
        }
        .unique
    }

    // MARK: - Coordinator

    var coordinator: Factory<Coordinator> {
        self { Coordinator() }
            .singleton
    }
}
