//
//  NotificationsSettingsView.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import SwiftUI
import UserNotifications

struct NotificationsSettingsView: View {
    @EnvironmentObject var notificationsManager: NotificationsManager
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        List {
            HStack(alignment: .center) {
                Toggle(
                    isOn: Binding(
                        get: { notificationsManager.notificationsIsOn },
                        set: { newValue in
                            print("Toggle value changed to: \(newValue)")
                            notificationsManager.notificationsIsOn = newValue
                            if newValue {
                                notificationsManager.enableNotifications()
                            } else {
                                notificationsManager.disableNotifications()
                            }
                        }
                    )
                ) {
                    Label("Отримувати сповіщення", systemImage: "bell")
                }
                .lineLimit(1)
                .foregroundStyle(Resources.ViewColors.text(forScheme: themeManager.colorScheme))
            }
        }
        .listStyle(.plain)
        .onAppear {
            notificationsManager.loadInitialState()
            print("Initial state loaded: \(notificationsManager.notificationsIsOn)")
        }
    }
}

#Preview {
    NotificationsSettingsView()
        .environmentObject(NotificationsManager())
}

