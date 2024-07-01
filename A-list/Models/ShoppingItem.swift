//
//  ShoppingItem.swift
//  A-list
//
//  Created by Екатерина Токарева on 30.06.2024.
//

import Foundation

struct ShoppingItem: Identifiable, Codable, Hashable {
    var title: String = ""
    var quantity: String = ""
    var unit: Unit = .pc
    var done = false
    var id = UUID().uuidString

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case quantity
        case unit
        case done
    }

    init(title: String, quantity: String, unit: Unit, done: Bool = false, id: String = UUID().uuidString) {
        self.title = title
        self.quantity = quantity
        self.unit = unit
        self.done = done
        self.id = id
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        title = try container.decode(String.self, forKey: .title)
        quantity = try container.decode(String.self, forKey: .quantity)
        unit = try container.decode(Unit.self, forKey: .unit)
        done = try container.decode(Bool.self, forKey: .done)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(unit, forKey: .unit)
        try container.encode(done, forKey: .done)
    }
}
