//
//  UserSettingsView.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import SwiftUI

struct UserSettingsView: View {
    @ObservedObject var viewModel = UserSettingsViewViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingLoginSheet = false
    
    var body: some View {
        Text("User")
        Spacer()
        footer
    }
    
    var footer: some View {
        Button {
            viewModel.logout()
            showingLoginSheet.toggle()
        } label: {
            Text("Вийти")
        }
        .foregroundStyle(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
        .fullScreenCover(isPresented: $showingLoginSheet, content: {
            LoginView()
        })
    }
}

#Preview {
    UserSettingsView()
}
