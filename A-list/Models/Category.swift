//
//  CategoryModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import Foundation

struct Category: Codable, Hashable {
    var name: String
    var lists: [ShoppingList]?
}
