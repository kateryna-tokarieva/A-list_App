//
//  NotificationsSettingsView.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import SwiftUI

struct NotificationsSettingsView: View {
    @EnvironmentObject var notificationsManager: NotificationsManager

    var body: some View {
        List {
            HStack {
                Toggle(
                    isOn: $notificationsManager.notificationsIsOn
                ) {
                    Label("Отримувати сповіщення", systemImage: "bell")
                }
                .padding()
            }
        }
    }
}

#Preview {
    NotificationsSettingsView()
        .environmentObject(NotificationsManager())
}

