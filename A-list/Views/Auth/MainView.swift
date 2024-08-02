//
//  MainView.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Group {
            if viewModel.showingHomeSheet, !viewModel.currentUserId.isEmpty {
                HomeView(userId: viewModel.currentUserId)
            } else {
                LoginView(viewModel: LoginViewModel())
            }
        }
        .onAppear {
        }
    }
}

