//
//  ColorsExtension.swift
//  Ecommerce
//
//  Created by Andrii Duda on 26.01.2026.
//

import SwiftUI

extension Color {
    // Primary Brand Colors
    static let primaryBlue = Color(hex: "#2C3E50")
    static let primaryOrange = Color(hex: "#E67E22")
    static let accentGreen = Color(hex: "#27AE60")

    // Background Colors
    static let backgroundPrimary = Color(hex: "#FFFFFF")
    static let backgroundSecondary = Color(hex: "#F8F9FA")
    static let backgroundTertiary = Color(hex: "#E9ECEF")

    // Text Colors
    static let textPrimary = Color(hex: "#212529")
    static let textSecondary = Color(hex: "#6C757D")
    static let textTertiary = Color(hex: "#ADB5BD")
    static let textInverse = Color(hex: "#FFFFFF")

    // UI Element Colors
    static let borderLight = Color(hex: "#DEE2E6")
    static let borderMedium = Color(hex: "#CED4DA")
    static let divider = Color(hex: "#E9ECEF")

    // Status Colors
    static let success = Color(hex: "#27AE60")
    static let warning = Color(hex: "#F39C12")
    static let error = Color(hex: "#E74C3C")
    static let info = Color(hex: "#3498DB")

    // Product & Commerce Specific
    static let priceRed = Color(hex: "#E74C3C")
    static let badgeRed = Color(hex: "#DC3545")
    static let ratingGold = Color(hex: "#F1C40F")
    static let outOfStock = Color(hex: "#95A5A6")

    // Cart & Checkout
    static let cartBadge = Color(hex: "#E74C3C")
    static let checkoutGreen = Color(hex: "#27AE60")

    // Helper initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted
        )
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a: UInt64
        let r: UInt64
        let g: UInt64
        let b: UInt64
        switch hex.count {
        case 3:  // RGB (12-bit)
            (a, r, g, b) = (
                255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17
            )
        case 6:  // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  // ARGB (32-bit)
            (a, r, g, b) = (
                int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF
            )
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
