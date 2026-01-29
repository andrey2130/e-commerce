//
//  ErrorState.swift
//  Ecommerce
//
//  Created by Andrii Duda on 29.01.2026.
//
import SwiftUI

struct ErrorState: View {
    var onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 40))
                .foregroundColor(.gray.opacity(0.6))

            Text("Something went wrong")
                .font(AppFont.title3)
                .foregroundColor(.primary)

            Text(
                "We’re having trouble connecting to the service.\nPlease try again."
            )
            .font(AppFont.callout)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)

            CustomButton(title: "Try Again") {
                onTap()
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
