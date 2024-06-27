//
//  ListModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import Foundation

struct ShoppingList: Codable, Hashable {
    var name: String
    var items: [ShoppingItem]?
    var dueDate: Date?
    var isDone = false
    var id = UUID().uuidString
}

struct ShoppingItem: Identifiable, Codable, Hashable {
    var title: String = ""
    var quantity: Double = 0
    var unit: Unit = .pc
    var done = false
    var id = UUID().uuidString
}

enum Unit: String, Codable {
    case ml = "мл."
    case l = "л."
    case g = "гр."
    case kg = "кг."
    case pc = "шт."
}
