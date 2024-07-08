//
//  NotificationsSettingsView.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import SwiftUI

struct NotificationsSettingsView: View {
    @EnvironmentObject var notificationsManager: NotificationsManager
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        List {
            HStack(alignment: .center) {
                Toggle(
                    isOn: $notificationsManager.notificationsIsOn
                ) {
                    Label("Отримувати сповіщення", systemImage: "bell")
                }
                .lineLimit(1)
                .foregroundStyle(Resources.ViewColors.text(forScheme: themeManager.colorScheme))
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    NotificationsSettingsView()
        .environmentObject(NotificationsManager())
}

