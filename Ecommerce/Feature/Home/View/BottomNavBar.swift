//
//  BottomNavBar.swift
//  Ecommerce
//
//  Created by Andrii Duda on 29.01.2026.
//

import SwiftUI

struct BottomNavBar: View {

    enum Tab {
        case home, favorites, profile
    }

    @State private var selectedTab: Tab = .home
    @Environment(DeepLinkManager.self) private var deepLink
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(Tab.home)
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
                .tag(Tab.favorites)
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(Tab.profile)
        }
        .navigationBarBackButtonHidden(true)
        .task {

            await handlePendingDeepLink()
        }
    }

    private func handlePendingDeepLink() async {
        guard let currentDeepLink = deepLink.currentDeepLink else { return }

        try? await Task.sleep(nanoseconds: 300_000_000)

        await MainActor.run {
            switch currentDeepLink {
            case .product(let id):
                coordinator.push(.productDetails(id: id))
            case .favorites:
                selectedTab = .favorites
            case .home:
                selectedTab = .home
            }

            deepLink.reset()
        }
    }
}
