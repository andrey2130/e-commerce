//
//  LaunchView 2.swift
//  Ecommerce
//
//  Created by Andrii Duda on 26.01.2026.
//

import SwiftUI

struct LaunchView: View {
    @Environment(Coordinator.self) private var coordinator

    @State private var scale: CGFloat = 0.92
    @State private var opacity: Double = 0.0

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 16) {
                logo
                    .scaleEffect(scale)
                    .opacity(opacity)

                VStack(spacing: 8) {
                    Text("CartFlow")
                        .font(AppFont.title)
                        .foregroundColor(.primary)

                    Text("Shop smarter, live better")
                        .font(AppFont.callout)
                        .foregroundColor(.gray)
                }
                .opacity(opacity)
            }

            Spacer()

            VStack(spacing: 12) {
                ProgressView()
                    .tint(.black)

                Text("Loading...")
                    .font(AppFont.caption)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                scale = 1
                opacity = 1
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                coordinator.push(.login)
            }
        }
    }

    private var logo: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.primaryOrange)
                .frame(width: 96, height: 96)

            Image(systemName: "cart.fill")
                .font(.system(size: 34, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    LaunchView()
}
