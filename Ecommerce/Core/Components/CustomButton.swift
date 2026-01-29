//
//  CustomButton.swift
//  Ecommerce
//
//  Created by Andrii Duda on 26.01.2026.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var font: Font?
    var textColor: Color = .white
    var backgroundColor: Color = .black
    var isTransparent: Bool = false
    var cornerRadius: CGFloat = 14
    var borderColor: Color = .clear
    var borderWidth: CGFloat = 1
    var isLoading: Bool = false
    var action: () -> Void
    var isDisabled: Bool = false

    // MARK: - Computed Properties
    private var currentTextColor: Color {
        if isDisabled {
            return .white
        }
        return isTransparent ? .primaryOrange : textColor
    }

    private var currentBorderColor: Color {
        return isTransparent ? .primaryOrange : borderColor
    }

    // MARK: - Body
    var body: some View {
        Button(action: {
            if !isLoading && !isDisabled {
                action()
            }
        }) {
            ZStack {
                Text(title)
                    .font(font)
                    .foregroundColor(currentTextColor)
                    .opacity(isLoading ? 0 : 1)

                if isLoading {
                    ProgressView()
                        .progressViewStyle(
                            CircularProgressViewStyle(
                                tint: .white
                            )
                        )
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(backgroundView)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(currentBorderColor, lineWidth: borderWidth)
            )

        }
        .disabled(isLoading || isDisabled)
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var backgroundView: some View {
        if isDisabled {
            Color.outOfStock
        } else if isTransparent {
            Color.clear
        } else {
            backgroundColor
        }
    }
}
