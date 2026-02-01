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
    }
}
