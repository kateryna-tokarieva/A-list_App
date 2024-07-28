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
        VStack {
            HStack {
                ForEach(ColorTheme.allCases, id: \.self) { theme in
                    Button(action: {
                        selectedTheme = theme.rawValue
                        themeManager.saveSelectedTheme(theme)
                    }, label: {
                        Circle()
                            .foregroundStyle(theme.colors.lighterAccentColor)
                            .shadow(color: theme.colors.darkerAccentColor, radius: Resources.Sizes.buttonCornerRadius, x: Resources.Sizes.buttonShadowOffset, y: Resources.Sizes.buttonShadowOffset)
                    })
                    .padding()
                }
            }
            Spacer()
        }
        .padding()
        .onAppear {
            themeManager.saveSelectedTheme(ColorTheme(rawValue: selectedTheme) ?? .modernClean)
        }
    }
}

#Preview {
    ModeSettingsView()
        .environmentObject(ThemeManager())
}
