//
//  SettingModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import Foundation
import SwiftUI

enum SettingsSection: String {
    case user = "Юзер"
    case friends = "Друзі"
    case calendar = "Календар"
    case mode = "Тема"
    case notifications = "Сповіщення"
    case support = "Підтримка"
    
    func image() -> Image? {
        switch self {
        case .user:
            Image(systemName: "person.circle")
        case .friends:
            Image(systemName: "person.3")
        case .calendar:
            Image(systemName: "calendar")
        case .mode:
            Image(systemName: "swatchpalette")
        case .notifications:
            Image(systemName: "bell")
        case .support:
            Image(systemName: "questionmark.circle")
        }
    }
}

struct Settings: Codable {
    var modeIsDark: Bool = false
    var notificationsIsOn: Bool = true
}
