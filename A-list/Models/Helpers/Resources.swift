//
//  Resources.swift
//  A-list
//
//  Created by Екатерина Токарева on 23.06.2024.
//

import Foundation
import SwiftUI

struct Resources {
    
    enum Images {
        static var background = Image("background")
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
        static var doNotHaveAccount = "Ще не маєте акканту?"
        static var makeAnAccount = "Створити аккаунт"
        static var email = "email"
        static var password = "пароль"
        static var login = "Вхід"
        static var name = "імʼя"
        static var registration = "Зареєструватись"
    }
    
    enum Numbers {
        static var buttonCornerRadius = 10
        static var buttonShadowRadius = 2
        static var listPreviewViewCornerRadius = 10
    }
    
    enum Colors {
        static var accentRed = Color(UIColor(red: 252/255, green: 60/255, blue: 6/255, alpha: 1))
        static var accentPink = Color(UIColor(red: 248/255, green: 189/255, blue: 215/255, alpha: 1))
        static var accentBlue = Color(UIColor(red: 21/255, green: 65/255, blue: 173/255, alpha: 1))
        static var text = Color(UIColor.black)
        static var base = Color(UIColor.white)
    }
    
    enum Views {
        enum Colors {
            static var borderedButtonTint = Resources.Colors.accentBlue
            static var borderedButtonText = Resources.Colors.accentPink
            static var borderedButtonShadow = Resources.Colors.accentPink
            static var errorMessage = Resources.Colors.accentRed
            static var plainButtonText = Resources.Colors.accentBlue
        }
    }
}
