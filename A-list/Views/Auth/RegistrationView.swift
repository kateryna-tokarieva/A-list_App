//
//  RegistrationView.swift
//  A-list
//
//  Created by Екатерина Токарева on 26.06.2024.
//

import SwiftUI

struct RegistrationView: View {
    @ObservedObject var viewModel = RegistrationViewViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack {
            VStack {
                TextField(Resources.Strings.name, text: $viewModel.name)
                    .keyboardType(.namePhonePad)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom)
                TextField(Resources.Strings.email, text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom)
                SecureField(Resources.Strings.password, text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
            
            Button(Resources.Strings.registration) {
                viewModel.register()
                guard !viewModel.userId.isEmpty else { return }
            }
            .frame(maxWidth: .infinity)
            .tint(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
            .foregroundStyle(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
            .buttonStyle(.borderedProminent)
            .clipShape(.rect(cornerRadius: CGFloat(Resources.Sizes.buttonCornerRadius)))
            .shadow(color: Resources.ViewColors.accentSecondary(forScheme: themeManager.colorScheme), radius: CGFloat(Resources.Sizes.buttonShadowRadius), x: CGFloat(Resources.Sizes.buttonShadowRadius), y: CGFloat(Resources.Sizes.buttonShadowRadius))
            .controlSize(.large)
            .padding()
            .fullScreenCover(isPresented: $viewModel.showingLoginSheet, content: {
                LoginView(viewModel: LoginViewModel(email: self.viewModel.email, password: self.viewModel.password))
            })
            Text(viewModel.error)
                .foregroundStyle(Resources.ViewColors.error(forScheme: themeManager.colorScheme))
                .padding()
        }
    }
}

#Preview {
    RegistrationView()
}
