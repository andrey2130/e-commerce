//
//  AppRouter.swift
//  Ecommerce
//
//  Created by Andrii Duda on 26.01.2026.
//

import SwiftUI

enum Page: String, Identifiable {
    case login, launch, register, onboarding, home

    var id: String {
        self.rawValue
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
        }
    }
}
