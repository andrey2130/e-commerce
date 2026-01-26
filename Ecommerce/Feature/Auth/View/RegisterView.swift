//
//  RegisterView.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//

import SwiftUI

struct RegisterView: View {
    @Environment(Coordinator.self) var coordinator
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                HeaderSection()
                    .padding(.bottom, 40)

                FormSection(
                    email: $email,
                    password: $password,
                    confirmPassword: $confirmPassword
                )
                .padding(.bottom, 24)

                FooterSection(onSignInTap: {
                    coordinator.pop()
                })
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
        }
    }
}

// MARK: - Header Section
struct HeaderSection: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Create Account")
                .font(AppFont.title)
                .foregroundColor(.primary)

            Text("Register to continue shopping")
                .font(AppFont.callout)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Form Section
struct FormSection: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String

    var body: some View {
        VStack(spacing: 16) {
            EmailFieldWidget(email: $email)
            PasswordFieldWidget(password: $password)
            ConfirmPasswordFieldWidget(confirmPassword: $confirmPassword)

            CustomButton(
                title: "Sign Up",
                font: AppFont.buttonSmall,
                backgroundColor: .black
            ) {
                // TODO: Sign up action
            }
        }
    }
}

// MARK: - Email Field Widget
struct EmailFieldWidget: View {
    @Binding var email: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Email")
                .font(AppFont.subhead)
                .foregroundColor(.primary)

            CustomTextField(title: "Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocorrectionDisabled()
        }
    }
}

// MARK: - Password Field Widget
struct PasswordFieldWidget: View {
    @Binding var password: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Password")
                .font(AppFont.subhead)
                .foregroundColor(.primary)

            CustomTextField(
                title: "Password",
                text: $password,
                isPassword: true
            )
            .textContentType(.newPassword)
        }
    }
}

// MARK: - Confirm Password Field Widget
struct ConfirmPasswordFieldWidget: View {
    @Binding var confirmPassword: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Confirm Password")
                .font(AppFont.subhead)
                .foregroundColor(.primary)

            CustomTextField(
                title: "Confirm Password",
                text: $confirmPassword,
                isPassword: true
            )
            .textContentType(.newPassword)
        }
    }
}

// MARK: - Footer Section
struct FooterSection: View {
    let onSignInTap: () -> Void

    var body: some View {
        HStack(spacing: 6) {
            Text("Already have an account?")
                .font(AppFont.subhead)
                .foregroundColor(.gray)

            Button(action: onSignInTap) {
                Text("Sign In")
                    .font(AppFont.subhead)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
        }
        .padding(.bottom, 24)
    }
}

#Preview {
    NavigationView {
        RegisterView()
    }
}
