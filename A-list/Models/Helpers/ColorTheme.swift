//
//  ColorTheme.swift
//  A-list
//
//  Created by Екатерина Токарева on 03.07.2024.
//

import SwiftUI

enum ColorTheme: String, CaseIterable, Codable {
    case modernClean = "Сучасна"
    case warmInviting = "Тепла"
    case softCute = "Ніжна"
}

struct ThemeColors {
    let baseBackground: Color
    let textColor: Color
    let secondaryTextColor: Color
    let darkerAccentColor: Color
    let lighterAccentColor: Color
    let errorColor: Color
}

extension ColorTheme {
    var colors: ThemeColors {
        switch self {
        case .modernClean:
            return ThemeColors(
                baseBackground: Color.white,
                textColor: Color(UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)),
                secondaryTextColor: Color(UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1)),
                darkerAccentColor: Color(UIColor(red: 42/255, green: 78/255, blue: 136/255, alpha: 1)),
                lighterAccentColor: Color(UIColor(red: 66/255, green: 99/255, blue: 151/255, alpha: 1)),
                errorColor: Color(UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1))
            )
        case .warmInviting:
            return ThemeColors(
                baseBackground: Color.white,
                textColor: Color(UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)),
                secondaryTextColor: Color(UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)),
                darkerAccentColor: Color(UIColor(red: 196/255, green: 132/255, blue: 23/255, alpha: 1)),
                lighterAccentColor: Color(UIColor(red: 255/255, green: 196/255, blue: 95/255, alpha: 1)),
                errorColor: Color(UIColor(red: 170/255, green: 115/255, blue: 57/255, alpha: 1))
            )
        case .softCute:
            return ThemeColors(
                baseBackground: Color.white,
                textColor: Color(UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)),
                secondaryTextColor: Color(UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1)),
                darkerAccentColor: Color(UIColor(red: 190/255, green: 95/255, blue: 129/255, alpha: 1)),
                lighterAccentColor: Color(UIColor(red: 224/255, green: 147/255, blue: 174/255, alpha: 1)),
                errorColor: Color(UIColor(red: 255/255, green: 69/255, blue: 0/255, alpha: 1))
            )
        }
    }

    var darkColors: ThemeColors {
        switch self {
        case .modernClean:
            return ThemeColors(
                baseBackground: Color(UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)),
                textColor: Color.white,
                secondaryTextColor: Color.gray,
                darkerAccentColor: Color(UIColor(red: 66/255, green: 99/255, blue: 151/255, alpha: 1)),
                lighterAccentColor: Color(UIColor(red: 42/255, green: 78/255, blue: 136/255, alpha: 1)),
                errorColor: Color(UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1))
            )
        case .warmInviting:
            return ThemeColors(
                baseBackground: Color(UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)),
                textColor: Color.white,
                secondaryTextColor: Color(UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)),
                darkerAccentColor: Color(UIColor(red: 255/255, green: 196/255, blue: 95/255, alpha: 1)),
                lighterAccentColor: Color(UIColor(red: 196/255, green: 132/255, blue: 23/255, alpha: 1)),
                errorColor: Color(UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1))
            )
        case .softCute:
            return ThemeColors(
                baseBackground: Color(UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)),
                textColor: Color.white,
                secondaryTextColor: Color(UIColor(red: 119/255, green: 119/255, blue: 119/255, alpha: 1)),
                darkerAccentColor: Color(UIColor(red: 224/255, green: 147/255, blue: 174/255, alpha: 1)),
                lighterAccentColor: Color(UIColor(red: 190/255, green: 95/255, blue: 129/255, alpha: 1)),
                errorColor: Color(UIColor(red: 255/255, green: 69/255, blue: 0/255, alpha: 1))
            )
        }
    }
}
