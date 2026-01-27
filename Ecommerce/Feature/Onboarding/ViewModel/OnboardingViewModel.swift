//
//  OnboardingViewModel.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//

import SwiftUI

@Observable
final class OnboardingViewModel {
    private let localStorage: LocalStorageService = .shared
    var currentTab: Int = 0
    var isFinished: Bool = false

    var onboardingContent: [OnboardingModel] {
        [
            OnboardingModel(
                title: "Browse thousands of products",
                description: "Discover popular items and categories in seconds",
                image: .onboarding1

            ),
            OnboardingModel(
                title: "Add to cart effortlessly",
                description: "Save items and manage your cart with ease",
                image: .onboarding2

            ),
            OnboardingModel(
                title: "Your order is delivered!",
                description: "Enjoy your new items",
                image: .onboarding3
            ),
        ]
    }

    func goNext() {
        if currentTab < onboardingContent.count - 1 {
            currentTab += 1
        } else {
            localStorage.markOnboardingAsComnpeted()
            isFinished = true
        }

    }

    func goSkip() {
        localStorage.markOnboardingAsComnpeted()
        isFinished = true
    }
}
