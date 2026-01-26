//
//  CustomTextField.swift
//  Ecommerce
//
//  Created by Andrii Duda on 26.01.2026.
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    var systemImage: String? = nil
    var keyboardType: UIKeyboardType = .default
    var backgroundColor: Color = .gray.opacity(0.1)
    var isPassword: Bool = false

    @State private var isSecure: Bool = true

    var body: some View {
        HStack(spacing: 12) {
            if let systemImage {
                Image(systemName: systemImage)
                    .foregroundColor(.gray)
            }

            Group {
                if isPassword && isSecure {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                }
            }
            .keyboardType(keyboardType)
            .autocapitalization(.none)

            if isPassword {
                Button {
                    isSecure.toggle()
                } label: {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}
