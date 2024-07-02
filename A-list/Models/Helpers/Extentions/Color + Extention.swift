//
//  UIColor + Extention.swift
//  A-list
//
//  Created by Екатерина Токарева on 02.07.2024.
//

import SwiftUI

extension Color {
    static let accentRed = Color(UIColor(red: 252/255, green: 60/255, blue: 6/255, alpha: 1))
    static let accentPink = Color(UIColor(red: 248/255, green: 189/255, blue: 215/255, alpha: 1))
    static let accentBlue = Color(UIColor(red: 21/255, green: 65/255, blue: 173/255, alpha: 1))
    static let text = Color.black
    static let subText = Color.gray
    static let base = Color.white

    static func themeColor(forScheme scheme: ColorScheme) -> Color {
        switch scheme {
        case .light:
            return .base
        case .dark:
            return .black
        @unknown default:
            return .base
        }
    }
}

