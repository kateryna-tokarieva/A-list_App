//
//  HomeViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 24.06.2024.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var allCategories = ["Всі списки", "Дім", "Робота", "Вечірка"]
    @Published var category = "Всі списки"
}
