//
//  ProfileView.swift
//  Ecommerce
//
//  Created by Andrii Duda on 29.01.2026.
//

import SwiftUI

struct ProfileView: View {
    @Environment(Coordinator.self) private var coordinator
    @State private var viewModel = ProfileViewModel()
    @State private var authViewModel = AuthViewModel()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                headerSection

                switch viewModel.authState {
                case .loading:
                    loadingSection

                case .authorized:
                    authorizedContent

                case .unauthorized:
                    guestContent

                case .error:
                    ErrorState {}
                        .padding(.top, 24)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            Task { await viewModel.getUser() }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                avatarView

                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.user?.name ?? "Sign in")
                        .font(AppFont.title)
                        .foregroundColor(.primary)
                        

                    Text(viewModel.user?.email ?? "")
                        .font(AppFont.body)
                        .foregroundColor(.secondary)
                        
                }

                Spacer()

                Button {

                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                        .padding(10)
                        .background(.thinMaterial)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }

            // quick actions
            HStack(spacing: 10) {
                QuickActionPill(icon: "shippingbox", title: "Orders") {
                    // coordinator.push(.orders)
                }
                QuickActionPill(icon: "heart", title: "Wishlist") {}
                QuickActionPill(icon: "ticket", title: "Coupons") {}
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }

    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.9), Color.purple.opacity(0.85),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 56, height: 56)

            Image(
                systemName:
                    "person"
            )
            .foregroundColor(.white)
            .font(.system(size: 22, weight: .semibold))
        }
        .overlay(
            Circle().stroke(Color.white.opacity(0.6), lineWidth: 1)
        )
    }

    // MARK: - States

    private var loadingSection: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("Loading profile…")
                .font(AppFont.subTitle)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 28)
    }

    private var authorizedContent: some View {
        VStack(spacing: 12) {

            // Account section
            SettingsSection(title: "My account") {
                SettingsRow(
                    icon: "bag",
                    title: "My Orders",
                    subtitle: "Track and manage"
                ) {}
                SettingsRow(
                    icon: "location",
                    title: "Addresses",
                    subtitle: "Shipping & billing"
                ) {}
                SettingsRow(
                    icon: "creditcard",
                    title: "Payment Methods",
                    subtitle: "Cards & Apple Pay"
                ) {}
            }

            // Support section
            SettingsSection(title: "Support") {
                SettingsRow(
                    icon: "questionmark.circle",
                    title: "Help Center",
                    subtitle: "FAQ & support"
                ) {}
                SettingsRow(
                    icon: "arrow.triangle.2.circlepath",
                    title: "Returns",
                    subtitle: "Return status"
                ) {}
            }

            CustomButton(title: "Log out") {
                authViewModel.logout()
                coordinator.push(.login)
            }
        }
        .padding(.top, 6)
    }

    private var guestContent: some View {
        VStack(spacing: 12) {

            SettingsSection(title: "Guest") {
                SettingsRow(
                    icon: "person.badge.key",
                    title: "Sign in",
                    subtitle: "Access your account"
                ) {
                    coordinator.push(.login)
                }
                SettingsRow(
                    icon: "person.badge.plus",
                    title: "Create account",
                    subtitle: "Fast checkout and wishlist"
                ) {
                    coordinator.push(.register)
                }
            }

            SettingsSection(title: "Why sign in?") {
                BenefitRow(icon: "shippingbox", title: "Track orders")
                BenefitRow(icon: "heart", title: "Wishlist")
                BenefitRow(icon: "tag", title: "Personal offers")
            }
        }
        .padding(.top, 6)
    }

}

// MARK: - Components

private struct QuickActionPill: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundColor(.primary)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title.uppercased())
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                content
            }
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
    }
}

private struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(.systemBackground))
                        .frame(width: 38, height: 38)

                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.system(size: 13, weight: .semibold))
            }
            .padding(14)
        }
        .buttonStyle(.plain)
        .overlay(alignment: .bottom) {
            Divider().padding(.leading, 64)
        }
    }
}

private struct BenefitRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.primary)
                .font(.system(size: 16, weight: .semibold))
                .frame(width: 22)

            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)

            Spacer()
        }
        .padding(14)
        .overlay(alignment: .bottom) {
            Divider().padding(.leading, 14)
        }
    }
}

#Preview {
    ProfileView()
        .environment(Coordinator())
}
