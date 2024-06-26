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
}

struct ShoppingItem: Identifiable, Codable, Hashable {
    var title: String = ""
    var quantity: Double = 0
    var unit: Unit = .pc
    var done = false
    var id = UUID()
}

enum Unit: Codable {
    case ml
    case l
    case g
    case kg
    case pc
}
