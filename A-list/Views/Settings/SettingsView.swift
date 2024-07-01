//
//  SettingsView.swift
//  A-list
//
//  Created by Екатерина Токарева on 24.06.2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel = SettingsViewModel()
    @State private var section: SettingsSection = .friends
    @State private var showingLoginSheet = false
    private var sections: [SettingsSection] = [.friends, .calendar, .mode, .notifications, .support]
    private var userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                HStack {
                    Resources.Images.userImagePlaceholder
                        .clipShape(.circle)
                        .scaledToFill()
                        .padding()
                    
                    VStack(alignment: .leading) {
                        Text(viewModel.user?.name ?? "")
                            .font(.title2)
                        Text(viewModel.user?.email ?? "")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                }
                Spacer()
                NavigationLink {
                    SettingsSectionView(viewModel: SettingsSectionViewModel(section: self.section))
                } label: {
                    Resources.Images.edit
                }
                .padding()
                .controlSize(.large)
                .tint(.red)
            }
            .padding()
            NavigationStack {
                List {
                    ForEach(sections, id: \.self) {section in
                        NavigationLink {
                            SettingsSectionView(viewModel: SettingsSectionViewModel(section: self.section)) } label: {
                                
                                HStack {
                                    section.image()
                                    Text(section.rawValue)
                                }
                            }
                    }
                }
            }
            Button {
                viewModel.logout()
                showingLoginSheet.toggle()
            } label: {
                Text("Вийти")
            }
            .fullScreenCover(isPresented: $showingLoginSheet, content: {
                LoginView()
            })
        }
    }
}
#Preview {
    SettingsView(userId: "3YIxHKN4ekMJ5V9zdJqkDgzEenI2")
}
