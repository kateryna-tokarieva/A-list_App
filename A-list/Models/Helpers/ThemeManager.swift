//
//  ThemeManager.swift
//  A-list
//
//  Created by Екатерина Токарева on 03.07.2024.
//

import Foundation
import SwiftUI

class ThemeManager: ObservableObject {
    @Published var currentTheme: ColorTheme
    @Published var colorScheme: ColorScheme
    
    init() {
        let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme") ?? ColorTheme.modernClean.rawValue
        self.currentTheme = ColorTheme(rawValue: savedTheme) ?? .modernClean
        self.colorScheme = UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
    }
    
    func saveSelectedTheme(_ theme: ColorTheme) {
        UserDefaults.standard.set(theme.rawValue, forKey: "selectedTheme")
        self.currentTheme = theme
        print(theme)
    }
    
    func toggleTheme() {
        self.colorScheme = (self.colorScheme == .light) ? .dark : .light
    }
}
