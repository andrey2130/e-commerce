//
//  AppRouter.swift
//  Ecommerce
//
//  Created by Andrii Duda on 26.01.2026.
//

import SwiftUI

enum Page: Hashable, Identifiable {
    case login, launch, register, onboarding, home, cart
    case productDetails(id: Int)
    case checkout
    case orders

    var id: String {
        switch self {
        case .login: "login"
        case .launch: "launch"
        case .register: "register"
        case .onboarding: "onboarding"
        case .home: "home"
        case .cart: "cart"
        case .checkout: "checkout"
        case .productDetails(let id): "productDetails_\(id)"
        case .orders: "orders"
        }
    }

}
@Observable
class Coordinator {
    var path = NavigationPath()
    var sheet: Page?

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

    func presentSheet(_ page: Page) {
        sheet = page
    }

    func dismissSheet() {
        sheet = nil
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
        case .cart:
            CartView()
        case .checkout:
            PaymentSheetView()
        case .productDetails(let id):
            ProductDetailsView(productId: id)
        case .orders:
            OrdersView()
        }
    }
}
