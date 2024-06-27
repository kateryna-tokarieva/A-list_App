//
//  UserModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import Foundation
import SwiftUI

struct User: Codable {
    var id: String = ""
    var name: String = ""
    var image: String = "person"
    var email: String = ""
    var friends: [String]?
    var categories: [Category] = [Category(name: "Всі списки")]
    var lists: [ShoppingList]?
    var events: [Date]?
    var settings: Settings
}
