//
//  Resources.swift
//  A-list
//
//  Created by Екатерина Токарева on 23.06.2024.
//

import SwiftUI

struct Resources {
    
    enum Images {
        static var background = Image("background")
        static var settings = Image(systemName: "gearshape")
        static var add = Image(systemName: "plus")
        static var checkmark = Image(systemName: "checkmark")
        static var userImagePlaceholder = Image(systemName: "person")
        static var edit = Image(systemName: "pencil")
        static var done = Image(systemName: "circle.fill")
        static var notDone = Image(systemName: "circle")
    }
    
    enum Strings {
        static var background = "Тисни + та створюй свій перший список покупок"
        static var welcome = "Вітаємо в A-list!"
        static var step1Title = "Назви свій список"
        static var step2Title = "Коли в магазин?"
        static var step3Title = "Вибери розділ"
        static var step4Title = "Додай необхідне"
        static var listNamePlaceholder = "Список 1"
        static var categoryNamePlaceholder = "Створи новий або обери ісснуючий"
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
        static var buttonShadowOffset: CGFloat = 2
        static var listPreviewFrame: CGFloat = UIScreen.main.bounds.width/2 - 20
        static var listPreviewCornerRadius: CGFloat = 10
        static var listPreviewShadowRadius: CGFloat = 2
        static var listPreviewShadowOffset: CGFloat = 2
    }
    
    enum ViewColors {
        static var borderedButtonTint = Color.accentBlue
        static var borderedButtonText = Color.accentPink
        static var borderedButtonShadow = Color.accentPink
        static var errorMessage = Color.accentRed
        static var plainButtonText = Color.accentBlue
    }
    
    enum Colors {
        static var accentRed = Color.accentRed
        static var accentPink = Color.accentPink
        static var accentBlue = Color.accentBlue
        static var text = Color.text
        static var subText = Color.subText
        static var base = Color.base
    }
    
    static func background(forColorScheme scheme: ColorScheme) -> Image {
        switch scheme {
        case .light:
            return Images.background
        case .dark:
            return Image("background.dark")
        @unknown default:
            return Images.background
        }
    }
}
