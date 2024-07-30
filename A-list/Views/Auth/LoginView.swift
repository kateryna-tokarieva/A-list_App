//
//  LoginView.swift
//  A-list
//
//  Created by Екатерина Токарева on 24.06.2024.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingRegistrationSheet = false
    @State private var showingPasswordResetSheet = false
    
    var body: some View {
        VStack {
            loginForm
            loginButton
            errorMessage
            registrationPrompt
        }
        .padding()
    }
    
    private var loginForm: some View {
        VStack {
            TextField(Resources.Strings.email, text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom)
            SecureField(Resources.Strings.password, text: $viewModel.password)
                .textFieldStyle(.roundedBorder)
            forgotPasswordButton
        }
    }
    
    private var forgotPasswordButton: some View {
        HStack {
            Spacer()
            Button(action: {
                showingPasswordResetSheet.toggle()
            }, label: {
                Text(Resources.Strings.forgotPassword)
                    .underline()
                    .foregroundStyle(Resources.ViewColors.subText(forScheme: themeManager.colorScheme))
                    .padding()
            })
            .sheet(isPresented: $showingPasswordResetSheet) {
                PasswordResetView(viewModel: PasswordResetViewModel())
            }
        }
    }
    
    private var loginButton: some View {
        Button(Resources.Strings.login) {
            handleLogin()
        }
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: true, vertical: false)
        .padding(.bottom)
        .tint(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
        .foregroundStyle(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
        .fullScreenCover(isPresented: $viewModel.showingHomeSheet) {
            HomeView(userId: viewModel.userId)
        }
        .buttonStyle(.borderedProminent)
        .clipShape(.rect(cornerRadius: CGFloat(Resources.Sizes.buttonCornerRadius)))
        .shadow(color: Resources.ViewColors.accentSecondary(forScheme: themeManager.colorScheme), radius: CGFloat(Resources.Sizes.buttonShadowRadius), x: CGFloat(Resources.Sizes.buttonShadowRadius), y: CGFloat(Resources.Sizes.buttonShadowRadius))
        .controlSize(.large)
        .padding()
    }
    
    private var errorMessage: some View {
        Text(viewModel.error)
            .foregroundStyle(Resources.ViewColors.error(forScheme: themeManager.colorScheme))
            .padding()
    }
    
    private var registrationPrompt: some View {
        VStack {
            Text(Resources.Strings.doNotHaveAccount)
                .foregroundStyle(Resources.ViewColors.text(forScheme: themeManager.colorScheme))
            Button {
                showingRegistrationSheet.toggle()
            } label: {
                Text(Resources.Strings.makeAnAccount).underline()
            }
            .foregroundStyle(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
            .sheet(isPresented: $showingRegistrationSheet) {
                RegistrationView(viewModel: RegistrationViewViewModel(email: self.viewModel.email, password: self.viewModel.password))
            }
        }
    }
    
    private func handleLogin() {
        viewModel.login()
    }
}
