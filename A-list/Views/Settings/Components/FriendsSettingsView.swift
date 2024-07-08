//
//  FriendsSettingsView.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import SwiftUI

struct FriendsSettingsView: View {
    @ObservedObject var viewModel = FriendsSettingsViewViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    @State private var email: String = ""
    
    var body: some View {
        VStack {
            
            TextField("Введіть email друга", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Відправити запит") {
                viewModel.addFriendByEmail(email: email) { success in
                    if success {
                        email = ""
                    } else {
                        // handle error case
                    }
                }
            }
            .tint(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
            .foregroundStyle(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
            .buttonStyle(.borderedProminent)
            .clipShape(.rect(cornerRadius: CGFloat(Resources.Sizes.buttonCornerRadius)))
            .shadow(color: Resources.ViewColors.accentSecondary(forScheme: themeManager.colorScheme), radius: CGFloat(Resources.Sizes.buttonShadowRadius), x: CGFloat(Resources.Sizes.buttonShadowRadius), y: CGFloat(Resources.Sizes.buttonShadowRadius))
            .controlSize(.large)
            .padding()
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            List {
                if !viewModel.friends.isEmpty {
                    ForEach(viewModel.friends, id: \.id) { friend in
                        Text(friend.name)
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.deleteFriend(friendId: friend.id) { success in
                                        if success {
                                            // Handle successful deletion if needed
                                        } else {
                                            // Handle deletion error if needed
                                        }
                                    }
                                } label: {
                                    Label("Видалити", systemImage: "trash")
                                }
                                .tint(Resources.ViewColors.error(forScheme: themeManager.colorScheme))
                                .foregroundStyle(Resources.ViewColors.base(forScheme: themeManager.colorScheme))
                            }
                    }
                }
            }
            .listStyle(.plain)
        }
        .padding()
    }
}

#Preview {
    FriendsSettingsView()
}
