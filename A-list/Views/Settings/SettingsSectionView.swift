//
//  SettingsSectionView.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import SwiftUI

struct SettingsSectionView: View {
    @ObservedObject var viewModel: SettingsSectionViewModel
    
    var body: some View {
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
}

#Preview {
    SettingsSectionView(viewModel: SettingsSectionViewModel(section: .calendar))
}
