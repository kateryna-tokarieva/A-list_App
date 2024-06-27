//
//  ListPreviewViewViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 27.06.2024.
//

import Foundation

class ListPreviewViewViewModel: ObservableObject {
    @Published var title = ""
    @Published var items: [ShoppingItem]?
    @Published var dueDate: Date?
    @Published var doneItems: Int = 0 
    
    init(title: String = "", items: [ShoppingItem]? = nil, dueDate: Date? = nil) {
        self.title = title
        self.items = items
        self.dueDate = dueDate
    }
    
    func updateDoneItemsCount() {
        guard let items else { return}
        for item in items {
            if item.done {
                doneItems += 1
            }
        }
    }
}
