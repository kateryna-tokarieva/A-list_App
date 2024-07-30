//
//  PasswordResetView.swift
//  A-list
//
//  Created by Екатерина Токарева on 21.07.2024.
//

import SwiftUI
import Combine

struct PasswordResetView: View {
    @StateObject var viewModel: PasswordResetViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Spacer()
            TextField(Resources.Strings.email, text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            Button(action: {
                viewModel.sendPasswordReset(email: viewModel.email)
            }) {
                Text(Resources.Strings.resetPassword)
            }
            .frame(maxWidth: .infinity)
            .fixedSize(horizontal: true, vertical: false)
            .padding(.bottom)
            .tint(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
            .foregroundStyle(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            .clipShape(.rect(cornerRadius: CGFloat(Resources.Sizes.buttonCornerRadius)))
            .shadow(color: Resources.ViewColors.accentSecondary(forScheme: themeManager.colorScheme), radius: CGFloat(Resources.Sizes.buttonShadowRadius), x: CGFloat(Resources.Sizes.buttonShadowRadius), y: CGFloat(Resources.Sizes.buttonShadowRadius))
            .controlSize(.large)
            .padding()
            
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(Resources.ViewColors.error(forScheme: themeManager.colorScheme))
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
        .onReceive(viewModel.successPublisher) { _ in
            presentationMode.wrappedValue.dismiss()
        }
    }
}
