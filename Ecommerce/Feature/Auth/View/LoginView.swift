//
//  LoginView.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//

import SwiftUI

struct LoginView: View {
    @Environment(Coordinator.self) private var coordinator
    @State private var viewModel = AuthViewModel()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                HeaderSection()
                    .padding(.bottom, 40)

                LoginForm(viewModel: viewModel)
                    .padding(.bottom, 24)

                FooterSection(onSignUpTap: {
                    coordinator.push(.register)
                })
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Header Section
private struct HeaderSection: View {
    var body: some View {
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
}

// MARK: - Login Form
private struct LoginForm: View {
    @Bindable var viewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 16) {
            FormField(
                label: "Email",
                placeholder: "Email",
                text: $viewModel.email
            ) { field in
                field
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocorrectionDisabled()
            }

            FormField(
                label: "Password",
                placeholder: "Password",
                text: $viewModel.password,
                isPassword: true
            ) { field in
                field.textContentType(.password)
            }

            CustomButton(
                title: "Sign In",
                font: AppFont.buttonSmall,
                backgroundColor: .black
            ) {
                Task {
                }
            }
        }
    }
}

// MARK: - Reusable Form Field
private struct FormField<Content: View>: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var isPassword: Bool = false
    var validationError: String?
    let configuration: (CustomTextField) -> Content

    init(
        label: String,
        placeholder: String,
        text: Binding<String>,
        isPassword: Bool = false,
        validationError: String? = nil,
        @ViewBuilder configuration: @escaping (CustomTextField) -> Content = {
            $0 as! Content
        }
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.isPassword = isPassword
        self.validationError = validationError
        self.configuration = configuration
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(AppFont.subhead)
                .foregroundColor(.primary)

            configuration(
                CustomTextField(
                    title: placeholder,
                    text: $text,
                    isPassword: isPassword
                )
            )

            if let error = validationError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

// MARK: - Footer Section
private struct FooterSection: View {
    let onSignUpTap: () -> Void

    var body: some View {
        HStack(spacing: 6) {
            Text("Don't have an account?")
                .font(AppFont.subhead)
                .foregroundColor(.gray)

            Button(action: onSignUpTap) {
                Text("Sign Up")
                    .font(AppFont.subhead)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
        }
    }
}

#Preview {
    LoginView()
}
