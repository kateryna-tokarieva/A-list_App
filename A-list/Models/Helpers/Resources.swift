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
    }
    
    enum Colors {
        static var accent = Color(UIColor(red: 237, green: 96, blue: 42, alpha: 1))
        static var background = Color(UIColor(red: 243, green: 205, blue: 222, alpha: 1))
        static var base = Color(UIColor(red: 41, green: 91, blue: 185, alpha: 1))
    }
}
