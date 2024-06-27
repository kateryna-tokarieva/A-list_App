//
//  AddListViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 23.06.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewListViewModel: ObservableObject {
    @Published var title = "--"
    @Published var titleTextFieldText = "--"
    @Published var progress: Float = 0
    @Published var titleTextFieldOpacity = 1
    @Published var skipButtonOpacity = 0
    @Published var categoryMenuOpacity = 0
    @Published var datePickerOpacity = 0
    @Published var dueDate = Date()
    @Published var category = "Всі списки"
    @Published var categoryTextFieldText = ""
    @Published var allCaterories = ["Всі списки", "Дім", "Робота", "Вечірка"]
    
    func update(step: NewListStep) {
        switch step {
        case .name:
            self.title = Resources.Strings.step1Title
            self.titleTextFieldText = Resources.Strings.listNamePlaceholder
            self.progress = 0.33
            self.titleTextFieldOpacity = 1
            self.skipButtonOpacity = 0
            self.categoryMenuOpacity = 0
            self.datePickerOpacity = 0
        case .timer:
            self.title = Resources.Strings.step2Title
            self.progress = 0.66
            self.titleTextFieldOpacity = 0
            self.skipButtonOpacity = 1
            self.categoryMenuOpacity = 0
            self.datePickerOpacity = 1
        case .category:
            self.title = Resources.Strings.step3Title
            self.categoryTextFieldText = Resources.Strings.categoryNamePlaceholder
            self.progress = 1
            self.titleTextFieldOpacity = 0
            self.skipButtonOpacity = 0
            self.categoryMenuOpacity = 1
            self.datePickerOpacity = 0
        }
    }
    
    func save() {
        guard let usedId = Auth.auth().currentUser?.uid else { return }
        let newList = ShoppingList(name: title, dueDate: dueDate, isDone: false)
        let dataBase = Firestore.firestore()
        dataBase.collection("users")
            .document(usedId)
            .collection("lists")
            .document(newList.id)
            .setData(newList.asDictionary())
    }
}
