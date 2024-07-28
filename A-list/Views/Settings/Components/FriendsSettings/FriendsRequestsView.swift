//
//  FriendsRequestsView.swift
//  A-list
//
//  Created by Екатерина Токарева on 10.07.2024.
//

import SwiftUI
import SegmentedPicker

struct FriendsRequestsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var viewModel = FriendRequestViewViewModel()
    @State private var selectedRequests = 0
    
    private enum RequestType: String, CaseIterable, Identifiable {
        case sent = "Відправлені"
        case recieved = "Отримані"
        var id: Self { self }
    }
    
    var body: some View {
        VStack {
            SegmentedPicker(
                RequestType.allCases,
                selectedIndex: Binding(
                    get: { selectedRequests },
                    set: { selectedRequests = $0 ?? 0 }),
                selectionAlignment: .bottom,
                content: { item, isSelected in
                    Text(item.rawValue)
                        .foregroundColor(isSelected ? Resources.ViewColors.accentSecondary(forScheme: themeManager.colorScheme) : Resources.ViewColors.subText(forScheme: themeManager.colorScheme ))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                },
                selection: {
                    VStack(spacing: 0) {
                        Spacer()
                        Resources.ViewColors.accent(forScheme: themeManager.colorScheme).frame(height: 1)
                    }
                })
            .onAppear {
                selectedRequests = 0
            }
            .animation(.easeInOut, value: 0.3)
            List {
                if selectedRequests == 0, let receivedRequestsUsers = viewModel.receivedRequestsUsers {
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
                } else if selectedRequests == 1, let sentRequestsUsers = viewModel.sentRequestsUsers {
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
