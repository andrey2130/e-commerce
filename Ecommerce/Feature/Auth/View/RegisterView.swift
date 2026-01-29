//
//  RegisterView.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//

import SwiftUI

struct RegisterView: View {
    @Environment(Coordinator.self) private var coordinator
    @State private var viewModel = AuthViewModel()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                HeaderSection()
                    .padding(.bottom, 40)

                RegisterForm(viewModel: viewModel)
                    .padding(.bottom, 24)

                FooterSection(onSignInTap: {
                    coordinator.pop()
                })
                .padding(.bottom, 24)
            }
            .onChange(of: viewModel.isRegistered) { _, registered in
                if registered {
                    coordinator.push(.home)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
        }
    }
}

// MARK: - Header Section
private struct HeaderSection: View {
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

// MARK: - Register Form
private struct RegisterForm: View {
    @Bindable var viewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 16) {
            FormField(
                label: "Name",
                placeholder: "Name",
                text: $viewModel.name,
                validationError: viewModel.validationError == .emptyName
                    ? "Name is required" : nil
            ) { field in
                field
                    .textInputAutocapitalization(.words)
                    .textContentType(.name)
                    .autocorrectionDisabled()
            }

            FormField(
                label: "Email",
                placeholder: "Email",
                text: $viewModel.email,
                validationError: [.emptyEmail, .invalidEmail].contains(
                    viewModel.validationError
                )
                    ? viewModel.validationError?.errorDescription : nil
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
                isPassword: true,
                validationError: [.emptyPassword, .shortPassword].contains(
                    viewModel.validationError
                )
                    ? viewModel.validationError?.errorDescription : nil
            ) { field in
                field.textContentType(.password)
            }

            FormField(
                label: "Confirm Password",
                placeholder: "Confirm Password",
                text: $viewModel.confirmPassword,
                isPassword: true,
                validationError: viewModel.validationError
                    == .passwordsDoNotMatch
                    ? "Passwords do not match" : nil
            ) { field in
                field.textContentType(.newPassword)
            }

            CustomButton(
                title: "Sign Up",
                font: AppFont.buttonSmall,
                backgroundColor: .black,
                isLoading: viewModel.isLoading
            ) {
                Task {
                    await viewModel.register()
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
    }
}

#Preview {
    RegisterView()
}
