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
    var sharedWithFriends: [String]?
    var dueDate: Date?
    var isDone = false
    var id = UUID().uuidString
    var notificationId: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case items
        case dueDate
        case isDone
        case sharedWithFriends
        case notificationId
    }

    init(id: String? = nil, name: String, items: [ShoppingItem]? = nil, dueDate: Date? = nil, isDone: Bool = false, sharedWithFriends: [String]? = nil, owner: String? = nil, notificationId: String? = nil) {
        self.id = id ?? UUID().uuidString
        self.name = name
        self.items = items
        self.dueDate = dueDate
        self.isDone = isDone
        self.sharedWithFriends = sharedWithFriends
        self.notificationId = notificationId
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        name = try container.decode(String.self, forKey: .name)
        items = try container.decodeIfPresent([ShoppingItem].self, forKey: .items)
        isDone = try container.decode(Bool.self, forKey: .isDone)
        sharedWithFriends = try container.decodeIfPresent([String].self, forKey: .sharedWithFriends)
        notificationId = try container.decodeIfPresent(String.self, forKey: .notificationId)
        
        if let timestamp = try? container.decode(Double.self, forKey: .dueDate) {
            dueDate = Date(timeIntervalSince1970: timestamp)
        } else {
            dueDate = try? container.decode(Date.self, forKey: .dueDate)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(items, forKey: .items)
        try container.encode(isDone, forKey: .isDone)
        try container.encode(sharedWithFriends, forKey: .sharedWithFriends)
        try container.encode(notificationId, forKey: .notificationId)
            
        if let dueDate = dueDate {
            try container.encode(dueDate.timeIntervalSince1970, forKey: .dueDate)
        }
    }
}
