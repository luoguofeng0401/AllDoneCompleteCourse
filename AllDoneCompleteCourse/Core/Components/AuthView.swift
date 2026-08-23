//
//  AuthView.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/23.
//

import SwiftUI

struct AuthView: View {
    
    @StateObject private var viewModel: AuthViewModel = .init()
    var body: some View {
        VStack(spacing: 20) {
            imageView
                .padding(.bottom, 20)
            headingView
            inputFieldsView
            forgotPasswordView
            authenticateButtonView
            authSwitchMessageView
        }
        .padding()
        .infinityFrame()
        .background(Color.appTheme.viewBackground)
        .showError(item: $viewModel.error)
        .showAlert(item:$viewModel.alert)
        .hideKeyboardOnTap()
        .keyboardToolbarDoneButton()
    }
}

private extension AuthView {
    var imageView: some View {
        Image(viewModel.currentAuthType.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: UIScreen.main.bounds.width / 1.3)
    }
    
    var headingView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.currentAuthType.title)
                .font(.title)
            Text(viewModel.currentAuthType.subtitle)
        }
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var inputFieldsView: some View {
        VStack(spacing: 12) {
            if viewModel.currentAuthType.isSignUp {
                TextField("First Name", text: $viewModel.firstName)
                    .textContentType(.givenName)
                    .textField(sfSymbol: "person")
                
                TextField("Last Name", text: $viewModel.lastName)
                    .textContentType(.givenName)
                    .textField(sfSymbol: "person")
            }
            
            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textField(sfSymbol: "envelope")
            
            SecureField("Password", text: $viewModel.password)
                .textContentType(.password)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textField(sfSymbol: "lock")
        }
    }
    
    @ViewBuilder
    var forgotPasswordView: some View {
        Button("Forgot Password?") {
            forgotPasswordButtonView
            forgotPasswordSuccessView
        }
    }
    
    @ViewBuilder
    var forgotPasswordButtonView: some View {
        if viewModel.currentAuthType.isSignIn {
            Text("Forgot Password?")
                .font(.footnote)
                .foregroundStyle(Color.appTheme.accent)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .button {
                    resetPassword()
                }
        }
    }
    
    @ViewBuilder
    var forgotPasswordSuccessView: some View {
        if viewModel.forgotPasswordSuccess {
            Text("Instructions to reset your password have been sent to your email.")
                .fixedSize(horizontal: false, vertical: true)
                .font(.callout)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.appTheme.alternateAccent)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    var authenticateButtonView: some View {
        Text(viewModel.currentAuthType.description)
            .primaryButton()
            .button(.press) {
                authenticate()
            }
    }
    
    var authSwitchMessageView: some View {
        HStack(spacing: 5) {
            Text(viewModel.currentAuthType.authSwitchMessage)
                .foregroundStyle(Color.appTheme.secondaryText)
            Text(viewModel.currentAuthType.oppositeTypeDescription)
                .fontWeight(.semibold)
                .foregroundStyle(Color.appTheme.accent)
                .shadow(.regular)
                .button {
                    toggleAuthType()
                }
        }
    }
}

private extension AuthView {
    func authenticate() {
        Task(handlingError: viewModel) {
            try await viewModel.authenticate()
        }
    }
    
    func resetPassword() {
        Task(handlingError: viewModel) {
            try await viewModel.resetPassword()
        }
    }
    
    func toggleAuthType() {
        viewModel.toggleAuthType()
    }
}

#Preview {
    AuthView()
}
