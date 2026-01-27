//
//  OnboardingView.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//

import SwiftUI

struct OnboardingView: View {
    var sr: LocalStorageService = .shared
    var body: some View {
        VStack {
            Text("Onboarding View")
            Button {
                sr.loguserOut()
            } label: {
                Text("Logout")
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
