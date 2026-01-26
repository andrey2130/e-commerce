//
//  Fonts_ext.swift
//  Ecommerce
//
//  Created by Andrii Duda on 26.01.2026.
//

import SwiftUI

enum AppFont {
    // MARK: - Headers & Titles
    static let largeTitle = Font.system(
        size: 34,
        weight: .bold,
        design: .rounded
    )
    static let title = Font.system(size: 28, weight: .bold, design: .rounded)
    static let title2 = Font.system(size: 24, weight: .bold)
    static let title3 = Font.system(size: 20, weight: .semibold)

    // MARK: - Headlines
    static let headline = Font.system(size: 18, weight: .semibold)
    static let subheadline = Font.system(size: 16, weight: .medium)

    // MARK: - Body Text
    static let body = Font.system(size: 16, weight: .regular)
    static let bodyMedium = Font.system(size: 16, weight: .medium)
    static let bodyBold = Font.system(size: 16, weight: .bold)

    // MARK: - Secondary Text
    static let callout = Font.system(size: 15, weight: .regular)
    static let subhead = Font.system(size: 14, weight: .medium)
    static let footnote = Font.system(size: 13, weight: .regular)
    static let caption = Font.system(size: 12, weight: .regular)
    static let caption2 = Font.system(size: 11, weight: .regular)

    // MARK: - E-Commerce Specific
    static let productName = Font.system(size: 18, weight: .semibold)
    static let productPrice = Font.system(
        size: 20,
        weight: .bold,
        design: .rounded
    )
    static let discountPrice = Font.system(size: 16, weight: .semibold)
    static let originalPrice = Font.system(size: 14, weight: .regular)
    static let categoryLabel = Font.system(size: 14, weight: .medium)
    static let badge = Font.system(size: 12, weight: .bold)
    static let rating = Font.system(size: 14, weight: .medium)

    // MARK: - Buttons
    static let buttonLarge = Font.system(size: 18, weight: .semibold)
    static let buttonMedium = Font.system(size: 16, weight: .semibold)
    static let buttonSmall = Font.system(size: 14, weight: .medium)

    // MARK: - Navigation
    static let navTitle = Font.system(size: 20, weight: .bold)
    static let tabBar = Font.system(size: 10, weight: .medium)

    // MARK: - Cart & Checkout
    static let cartTotal = Font.system(
        size: 24,
        weight: .bold,
        design: .rounded
    )
    static let cartItemName = Font.system(size: 16, weight: .medium)
    static let cartItemPrice = Font.system(size: 16, weight: .semibold)
    static let quantity = Font.system(size: 14, weight: .medium)

    // MARK: - Special Effects
    static let promotional = Font.system(
        size: 22,
        weight: .heavy,
        design: .rounded
    )
    static let saleTag = Font.system(size: 14, weight: .bold)

    // MARK: - Legacy (for backward compatibility)
    static let title_old = Font.system(size: 24, weight: .bold)
    static let subTitle = Font.system(size: 18, weight: .semibold)
    static let price = Font.system(size: 18, weight: .semibold)
}
