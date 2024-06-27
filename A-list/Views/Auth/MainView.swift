//
//  MainView.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            HomeView(userId: viewModel.currentUserId)
        } else {
            LoginView()
        }
    }
}

#Preview {
    MainView()
}
