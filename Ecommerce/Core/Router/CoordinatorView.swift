//
//  CoordinatorView.swift
//  Ecommerce
//
//  Created by Andrii Duda on 26.01.2026.
//

import SwiftUI

struct CoordinatorView: View {
    @State private var coordinator = Coordinator()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.buid(page: .launch)
                .navigationDestination(for: Page.self) { page in
                    coordinator.buid(page: page)
                }
        }
        .environment(coordinator)

    }
}
