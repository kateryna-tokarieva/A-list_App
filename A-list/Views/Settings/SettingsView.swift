//
//  SettingsView.swift
//  A-list
//
//  Created by Екатерина Токарева on 24.06.2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel = SettingsViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    private var userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    var body: some View {
        VStack {
            header
            content
            Spacer()
        }
    }
    
    var header: some View {
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
        }
        .padding()
    }
    
    var content: some View {
        NavigationStack {
            List {
                ForEach(SettingsSection.allCases, id: \.self) {section in
                    NavigationLink {
                        SettingsSectionView(viewModel: SettingsSectionViewModel(section: section)) } label: {
                            
                            HStack {
                                section.image()
                                Text(section.rawValue)
                            }
                        }
                }
            }
            .listStyle(.plain)
        }
    }
}
#Preview {
    SettingsView(userId: "3YIxHKN4ekMJ5V9zdJqkDgzEenI2")
}
