//
//  ListViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 23.06.2024.
//

import Foundation

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

