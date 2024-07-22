//
//  SupportSettingsView.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import SwiftUI

struct SupportSettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var viewModel = SupportSettingsViewViewModel()
    
    var body: some View {
        VStack {
            Text("Маєш пропозиції щодо покращення застосунку?")
                .padding()
            TextField("Напиши сюди", text: $viewModel.message)
                .textFieldStyle(.roundedBorder)
                .padding()
            Button(action: {
                viewModel.sendMessage()
            }, label: {
                Text("Відправити")
            })
            .buttonStyle(.borderedProminent)
            .clipShape(RoundedRectangle(cornerRadius: Resources.Sizes.buttonCornerRadius))
            .foregroundStyle(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
            .tint(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
            .padding()
            .shadow(color: Resources.ViewColors.accentSecondary(forScheme: themeManager.colorScheme), radius: Resources.Sizes.buttonCornerRadius, x: Resources.Sizes.buttonShadowOffset, y: Resources.Sizes.buttonShadowOffset)
            .controlSize(.large)
            .disabled(viewModel.message.isEmpty)
        }
        .padding()
        .sheet(isPresented: $viewModel.showingMailView) {
            MailView(result: self.$viewModel.result, recipients: ["kate.tokareva@icloud.com"], subject: "Підтримка", messageBody: viewModel.message)
        }
        Spacer()
    }
}

#Preview {
    SupportSettingsView()
}
