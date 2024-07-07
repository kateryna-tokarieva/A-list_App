//
//  ModeSettingsView.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import SwiftUI

struct ModeSettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @AppStorage("selectedTheme") var selectedTheme: String = ColorTheme.modernClean.rawValue

    var body: some View {
        List {
            ForEach(ColorTheme.allCases, id: \.self) { theme in
                HStack {
                    Text(theme.rawValue.capitalized)
                    Spacer()
                    if selectedTheme == theme.rawValue {
                        Image(systemName: "checkmark")
                            .foregroundColor(Resources.ViewColors.accentSecondary(forScheme: themeManager.colorScheme))
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedTheme = theme.rawValue
                    themeManager.saveSelectedTheme(theme)
                }
            }
        }
        .onAppear {
            themeManager.saveSelectedTheme(ColorTheme(rawValue: selectedTheme) ?? .modernClean)
        }
    }
}

#Preview {
    ModeSettingsView()
        .environmentObject(ThemeManager())
}
