//
//  ListViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 23.06.2024.
//

import Foundation
import SwiftUI

class ListViewModel: ObservableObject {
    @Published var title: String
    @Published var category: String
    @Published var shoppingItems: [ShoppingItem] = []
    
    init(title: String, category: String, shoppingItems: [ShoppingItem] = []) {
        self.title = title
        self.shoppingItems = shoppingItems
        self.category = category
    }
    
    func addItem(_ item: ShoppingItem) {
        shoppingItems.append(item)
    }
}

struct ShoppingItem: Identifiable {
    var title: String = ""
    var quantity: Double = 0
    var unit: Unit = .pc
    var done = false
    let id = UUID()
}

enum Unit {
    case ml
    case l
    case g
    case kg
    case pc
}
