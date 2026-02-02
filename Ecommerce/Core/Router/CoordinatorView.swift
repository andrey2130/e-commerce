//
//  CoordinatorView.swift
//  Ecommerce
//
//  Created by Andrii Duda on 26.01.2026.
//

import SwiftUI

struct CoordinatorView: View {
    @State private var coordinator = Coordinator()
    @State private var auth = AuthViewModel()
    @State private var favorites = FavoritesViewModel()
    @State private var deepLink = DeepLinkManager()
    @State private var isLaunchComplete = false

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.buid(page: .launch)
                .navigationDestination(for: Page.self) { page in
                    coordinator.buid(page: page)
                }
        }
        .environment(favorites)
        .environment(auth)
        .environment(coordinator)
        .environment(deepLink)
        .onOpenURL { url in
            deepLink.handle(url)

        }
        .onChange(of: deepLink.currentDeepLink) { oldValue, newValue in
            if isLaunchComplete, newValue != nil {
                handleDeepLinkImmediately(newValue)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .launchComplete)) {
            _ in
            isLaunchComplete = true
        }
    }

    private func handleDeepLinkImmediately(_ deepLink: DeepLinks?) {
        guard let deepLink = deepLink else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            switch deepLink {
            case .product(let id):
                coordinator.push(.productDetails(id: id))
            case .home:
                coordinator.popToRoot()
                coordinator.push(.home)
            case .favorites:
                coordinator.popToRoot()
                coordinator.push(.home)
            }

            self.deepLink.reset()
        }
    }
}
