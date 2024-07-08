//
//  UserModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import Foundation
import SwiftUI

struct User: Codable, Hashable {
    var id: String
    var name: String
    var image: String
    var email: String
    var friends: [String]
    var lists: [ShoppingList]?
    var events: [Date]?
    var settings: Settings
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

