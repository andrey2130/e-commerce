//
//  FieldErrorText.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//
import SwiftUI

struct FieldErrorText: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.red)
            .transition(.opacity)
    }
}
