//
//  FriendsRequestsView.swift
//  A-list
//
//  Created by Екатерина Токарева on 10.07.2024.
//

import SwiftUI

struct FriendsRequestsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var viewModel = FriendRequestViewViewModel()
    @State private var selectedRequests: RequestType = .recieved
    
    private enum RequestType: String, CaseIterable, Identifiable {
        case sent, recieved
        var id: Self { self }
    }
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedRequests) {
                Text("Отримані").tag(RequestType.recieved)
                Text("Відправлені").tag(RequestType.sent)
            }
            .padding()
            .pickerStyle(.segmented)
            .tint(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
            List {
                if selectedRequests == .recieved, let receivedRequestsUsers = viewModel.receivedRequestsUsers {
                    ForEach(receivedRequestsUsers, id: \.id) { friend in
                        HStack {
                            Text(friend.name)
                                .padding()
                                .foregroundStyle(Resources.ViewColors.text(forScheme: themeManager.colorScheme))
                            Spacer()
                            Button(action: {
                                
                            }, label: {
                                Image(systemName: "checkmark.circle")
                                    .tint(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
                            })
                        }
                    }
                } else if selectedRequests == .sent, let sentRequestsUsers = viewModel.sentRequestsUsers {
                    ForEach(sentRequestsUsers, id: \.id) { friend in
                        Text(friend.name)
                            .padding()
                            .foregroundStyle(Resources.ViewColors.text(forScheme: themeManager.colorScheme))
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    FriendsRequestsView()
}
