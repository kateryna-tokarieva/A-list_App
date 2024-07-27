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
    @EnvironmentObject var userSettingsViewModel: UserSettingsViewViewModel
    private var userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    var body: some View {
        VStack {
            header
            content
            Spacer()
                .onAppear {
                    viewModel.user = userSettingsViewModel.user
                    viewModel.profileImage = userSettingsViewModel.profileImage
                }
                .onChange(of: userSettingsViewModel.user?.name) {
                    viewModel.fetchUser()
                }
                .onChange(of: userSettingsViewModel.profileImage) {
                    viewModel.profileImage = userSettingsViewModel.profileImage
                }
        }
    }
    
    var header: some View {
        HStack(alignment: .center) {
            HStack {
                if let image = viewModel.profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .clipped()
                        .padding()
                } else {
                    Resources.Images.userImagePlaceholder
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding()
                }
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
