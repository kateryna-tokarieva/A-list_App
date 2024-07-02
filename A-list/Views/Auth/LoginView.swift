//
//  LoginView.swift
//  A-list
//
//  Created by Екатерина Токарева on 24.06.2024.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel(email: "", password: "")
    @State private var showingRegistrationSheet = false
    
    var body: some View {
        VStack {
            VStack {
                TextField(Resources.Strings.email, text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom)
                SecureField(Resources.Strings.password, text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
            
            Button(Resources.Strings.login) {
                viewModel.login()
                guard !viewModel.userId.isEmpty else { return }
            }
            .frame(maxWidth: .infinity)
            .fixedSize(horizontal: true, vertical: false)
            .padding(.bottom)
            .tint(Resources.ViewColors.borderedButtonTint)
            .foregroundStyle(Resources.ViewColors.borderedButtonText)
            .fullScreenCover(isPresented: $viewModel.showingHomeSheet, content: {
                HomeView(userId: viewModel.userId)
            })
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            .clipShape(.rect(cornerRadius: CGFloat(Resources.Sizes.buttonCornerRadius)))
            .shadow(color: Resources.ViewColors.borderedButtonShadow, radius: CGFloat(Resources.Sizes.buttonShadowRadius), x: CGFloat(Resources.Sizes.buttonShadowRadius), y: CGFloat(Resources.Sizes.buttonShadowRadius))
            .controlSize(.large)
            .padding()
            Text(viewModel.error)
                .foregroundStyle(Resources.ViewColors.errorMessage)
                .padding()
            
            VStack {
                Text(Resources.Strings.doNotHaveAccount)
                    .foregroundStyle(Resources.Colors.text)
                Button {
                    showingRegistrationSheet.toggle()
                } label: {
                    Text(Resources.Strings.makeAnAccount).underline()
                }
                .foregroundStyle(Resources.ViewColors.plainButtonText)
                .sheet(isPresented: $showingRegistrationSheet, content: {
                    RegistrationView(viewModel: RegistrationViewViewModel(email: self.viewModel.email, password: self.viewModel.password))
                })
            }
        }
    }
}

#Preview {
    LoginView()
}
