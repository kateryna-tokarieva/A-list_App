//
//  SettingsSectionView.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import SwiftUI

struct SettingsSectionView: View {
    @ObservedObject var viewModel: SettingsSectionViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            switch viewModel.section {
            case .user:
                UserSettingsView()
            case .friends:
                FriendsSettingsView()
            case .calendar:
                CalendarSettingsView()
            case .mode:
                ModeSettingsView()
            case .notifications:
                NotificationsSettingsView()
            case .support:
                SupportSettingsView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Назад")
                    }
                    .foregroundStyle(Resources.ViewColors.accent(forScheme: themeManager.colorScheme))
                }
            }
        }
    }
}

#Preview {
    SettingsSectionView(viewModel: SettingsSectionViewModel(section: .calendar))
        .environmentObject(ThemeManager())
}
