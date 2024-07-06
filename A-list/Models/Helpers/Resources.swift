//
//  Resources.swift
//  A-list
//
//  Created by Екатерина Токарева on 23.06.2024.
//

import SwiftUI

struct Resources {
    
    static var themeManager: ThemeManager?
    
    static var currentTheme: ColorTheme {
        return themeManager?.currentTheme ?? .modernClean
    }
    
    static var currentColorScheme: ColorScheme {
        return themeManager?.colorScheme ?? .light
    }
    
    enum Images {
        static func background(forScheme scheme: ColorScheme) -> Image {
            switch scheme {
            case .light:
                return Image("background")
            case .dark:
                return Image("background.dark")
            @unknown default:
                return Image("background")
            }
        }
        
        static var settings = Image(systemName: "gearshape")
        static var add = Image(systemName: "plus")
        static var checkmark = Image(systemName: "checkmark")
        static var userImagePlaceholder = Image(systemName: "person")
        static var edit = Image(systemName: "pencil")
        static var done = Image(systemName: "circle.fill")
        static var notDone = Image(systemName: "circle")
        static var barcode = Image(systemName: "barcode.viewfinder")
    }
    
    enum Strings {
        static var background = "Тисни + та створюй свій перший список покупок"
        static var welcome = "Вітаємо в A-list!"
        static var step1Title = "Назви свій список"
        static var step2Title = "Коли в магазин?"
        static var step3Title = "Вибери розділ"
        static var step4Title = "Додай необхідне"
        static var listNamePlaceholder = "Список 1"
        static var categoryNamePlaceholder = "Створи новий або обери існуючий"
        static var itemNamePlaceholder = "Назва продукту"
        static var doNotHaveAccount = "Ще не маєте аккаунту?"
        static var makeAnAccount = "Створити аккаунт"
        static var email = "email"
        static var password = "пароль"
        static var login = "Вхід"
        static var name = "імʼя"
        static var registration = "Зареєструватись"
        static var allLists = "Всі списки"
        static var skip = "Пропустити"
        static var setupNotification = "Постав нагадування"
        static var title = "Назва"
        static var quantity = "Кількість"
        static var deleteConfirmationAlertTitle = "Підтвердження"
        static var deleteConfirmationAlertContent = "Ви впевнені, що хочете видалити цей список?"
        static var deleteConfirmationAlertPrimaryButton = "Видалити"
    }
    
    enum Sizes {
        static var buttonCornerRadius: CGFloat = 10
        static var buttonShadowRadius: CGFloat = 2
        static var buttonShadowOffset: CGFloat = 4
        static var listPreviewFrame: CGFloat = UIScreen.main.bounds.width/2 - 20
        static var listPreviewCornerRadius: CGFloat = 10
        static var listPreviewShadowRadius: CGFloat = 4
        static var listPreviewShadowOffset: CGFloat = 4
    }
    
    enum ViewColors {
        static func accent(forScheme scheme: ColorScheme) -> Color {
            switch scheme {
            case .light:
                return currentTheme.colors.darkerAccentColor
            case .dark:
                return currentTheme.darkColors.darkerAccentColor
            @unknown default:
                return currentTheme.colors.darkerAccentColor
            }
        }
        
        static func accentSecondary(forScheme scheme: ColorScheme) -> Color {
            switch scheme {
            case .light:
                return currentTheme.colors.lighterAccentColor
            case .dark:
                return currentTheme.darkColors.lighterAccentColor
            @unknown default:
                return currentTheme.colors.lighterAccentColor
            }
        }
        
        static func error(forScheme scheme: ColorScheme) -> Color {
            switch scheme {
            case .light:
                return currentTheme.colors.errorColor
            case .dark:
                return currentTheme.darkColors.errorColor
            @unknown default:
                return currentTheme.colors.errorColor
            }
        }
        
        static func text(forScheme scheme: ColorScheme) -> Color {
            switch scheme {
            case .light:
                return currentTheme.colors.textColor
            case .dark:
                return currentTheme.darkColors.textColor
            @unknown default:
                return currentTheme.colors.textColor
            }
        }
        
        static func subText(forScheme scheme: ColorScheme) -> Color {
            switch scheme {
            case .light:
                return currentTheme.colors.secondaryTextColor
            case .dark:
                return currentTheme.darkColors.secondaryTextColor
            @unknown default:
                return currentTheme.colors.secondaryTextColor
            }
        }
        
        static func base(forScheme scheme: ColorScheme) -> Color {
            switch scheme {
            case .light:
                return currentTheme.colors.baseBackground
            case .dark:
                return currentTheme.darkColors.baseBackground
            @unknown default:
                return currentTheme.colors.baseBackground
            }
        }
    }
}
