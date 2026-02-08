//
//  StatusBadge.swift
//  Ecommerce
//
//  Created by Andrii Duda on 08.02.2026.
//

import SwiftUI

struct StatusBadge: View {
    let status: String

    var body: some View {
        Text(status.capitalized)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.15))
            .foregroundStyle(statusColor)
            .clipShape(Capsule())
    }

    private var statusColor: Color {
        switch status.lowercased() {
        case "completed": return .green
        case "pending": return .orange
        case "cancelled": return .red
        default: return .gray
        }
    }
}
