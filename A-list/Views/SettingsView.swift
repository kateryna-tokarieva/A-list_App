//
//  SettingsView.swift
//  A-list
//
//  Created by Екатерина Токарева on 24.06.2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    var sections: [SettingsSection] = [.friends, .categories, .calendar, .mode, .notifications, .support]
    @State var section: SettingsSection = .friends
    
    
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                HStack {
                    Image(systemName:viewModel.user.image)
                        .clipShape(.circle)
                        .scaledToFill()
                        .padding()
                    
                    VStack(alignment: .leading) {
                        Text(viewModel.user.name)
                            .font(.title2)
                        Text(viewModel.user.email)
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                }
                Spacer()
                NavigationLink {
                    SettingsSectionView(viewModel: SettingsSectionViewModel(section: self.section, user: viewModel.user))
                } label: {
                    Image(systemName: "pencil")
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
                            SettingsSectionView(viewModel: SettingsSectionViewModel(section: self.section, user: viewModel.user)) } label: {
                                
                                HStack {
                                    section.image()
                                    Text(section.rawValue)
                                }
                            }
                    }
                }
            }
        }
    }
}
#Preview {
    SettingsView(viewModel: SettingsViewModel(user: User(name: "Катерина", image: "person", email: "user@icloud.com", settings: Settings(modeIsDark: false, notificationsIsOn: true))))
}
