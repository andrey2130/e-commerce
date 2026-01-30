//
//  AppRouter.swift
//  Ecommerce
//
//  Created by Andrii Duda on 26.01.2026.
//

import SwiftUI

enum Page: Hashable, Identifiable {
    case login, launch, register, onboarding, home
    case productDetails(id: Int)

    var id: String {
        switch self {
        case .login: "login"
        case .launch: "launch"
        case .register: "register"
        case .onboarding: "onboarding"
        case .home: "home"
        case .productDetails(let id): "productDetails_\(id)"
        }
    }

}
@Observable
class Coordinator {
    var path = NavigationPath()

    func push(_ page: Page) {
        path.append(page)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    @ViewBuilder
    func buid(page: Page) -> some View {
        switch page {
        case .launch:
            LaunchView()
        case .login:
            LoginView()
        case .register:
            RegisterView()
        case .onboarding:
            OnboardingView()
        case .home:
            BottomNavBar()
        case .productDetails(let id):
            ProductDetailsView(productId: id)
        }
    }
}
