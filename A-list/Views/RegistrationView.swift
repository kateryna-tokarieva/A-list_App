//
//  RegistrationView.swift
//  A-list
//
//  Created by Екатерина Токарева on 26.06.2024.
//

import SwiftUI

struct RegistrationView: View {
    @ObservedObject var viewModel = RegistrationViewViewModel()
    
    var body: some View {
        VStack {
            VStack {
                TextField(Resources.Strings.name, text: $viewModel.name)
                    .keyboardType(.emailAddress)
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
            .tint(Resources.Views.Colors.borderedButtonTint)
            .foregroundStyle(Resources.Views.Colors.borderedButtonText)
            .buttonStyle(.borderedProminent)
            .clipShape(.rect(cornerRadius: CGFloat(Resources.Numbers.buttonCornerRadius)))
            .shadow(color: Resources.Views.Colors.borderedButtonShadow, radius: CGFloat(Resources.Numbers.buttonShadowRadius), x: CGFloat(Resources.Numbers.buttonShadowRadius), y: CGFloat(Resources.Numbers.buttonShadowRadius))
            .controlSize(.large)
            .padding()
            .fullScreenCover(isPresented: $viewModel.showingLoginSheet, content: {
                LoginView(viewModel: LoginViewModel(email: self.viewModel.email, password: self.viewModel.password))
            })
            Text(viewModel.error)
                .foregroundStyle(Resources.Views.Colors.errorMessage)
                .padding()
        }
    }
}

#Preview {
    RegistrationView()
}
