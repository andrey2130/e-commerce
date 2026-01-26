//
//  LoginView.swift
//  Ecommerce
//
//  Created by Andrii Duda on 26.01.2026.
//

import SwiftUI

struct LoginView: View {
    @Environment(Coordinator.self) var coordinator
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                header
                    .padding(.bottom, 40)

                form
                    .padding(.bottom, 24)

                footer
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Components
extension LoginView {

    fileprivate var header: some View {
        VStack(spacing: 12) {
            Text("Welcome Back")
                .font(AppFont.title)
                .foregroundColor(.primary)

            Text("Sign in to continue shopping")
                .font(AppFont.callout)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    fileprivate var form: some View {
        VStack(spacing: 16) {
            emailField
            passwordField
            forgotPasswordButton

            CustomButton(
                title: "Sign In",
                font: AppFont.buttonSmall,
                backgroundColor: .black
            ) {
                // TODO: Sign in action
            }
        }
    }

    fileprivate var emailField: some View {
        LabeledField(title: "Email") {
            CustomTextField(title: "Email", text: $email)
        }
    }

    fileprivate var passwordField: some View {
        LabeledField(title: "Password") {
            // If later you want show/hide password, swap this for your own field
            CustomTextField(
                title: "Password",
                text: $password,
                isPassword: true
            )
        }
    }

    fileprivate var forgotPasswordButton: some View {
        Button {
            // TODO: forgot password action
        } label: {
            Text("Forgot Password?")
                .font(AppFont.subhead)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    fileprivate var footer: some View {
        HStack(spacing: 4) {
            Text("Don't have an account?")
                .font(AppFont.subhead)
                .foregroundColor(.gray)

            Button {
                coordinator.push(.register)
            } label: {
                Text("Sign Up")
                    .font(AppFont.subhead)
                    .fontWeight(.semibold)  
                    .foregroundColor(.black)
            }
        }
        .padding(.bottom, 24)
    }
}

// MARK: - Reusable small view
private struct LabeledField<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppFont.subhead)
                .foregroundColor(.primary)

            content
        }
    }
}

#Preview {
    NavigationView {
        LoginView()
    }
}
