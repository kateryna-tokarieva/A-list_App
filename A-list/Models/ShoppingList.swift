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
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case items
        case dueDate
        case isDone
    }
    
    init(id: String? = nil, name: String, items: [ShoppingItem]? = nil, dueDate: Date? = nil, isDone: Bool = false) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.items = items
        self.dueDate = dueDate
        self.isDone = isDone
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        name = try container.decode(String.self, forKey: .name)
        items = try container.decodeIfPresent([ShoppingItem].self, forKey: .items)
        isDone = try container.decode(Bool.self, forKey: .isDone)
        
        if let timestamp = try? container.decode(Double.self, forKey: .dueDate) {
            dueDate = Date(timeIntervalSince1970: timestamp)
        } else {
            dueDate = try? container.decode(Date.self, forKey: .dueDate)
        }
    }
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
