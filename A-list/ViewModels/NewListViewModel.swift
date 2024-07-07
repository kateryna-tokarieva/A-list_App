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
    @Published var listTitle = Resources.Strings.listNamePlaceholder
    @Published var stepTitle = Resources.Strings.step1Title
    @Published var progress: Float = 0.5
    @Published var textFieldOpacity = 1
    @Published var skipButtonOpacity = 0
    @Published var datePickerOpacity = 0
    @Published var dueDate = Date()
    @Published var listId = ""
    
    func update(step: NewListStep) {
        switch step {
        case .name:
            self.stepTitle = Resources.Strings.step1Title
            self.listTitle = Resources.Strings.listNamePlaceholder
            self.progress = 0.5
            self.textFieldOpacity = 1
            self.skipButtonOpacity = 0
            self.datePickerOpacity = 0
        case .timer:
            self.stepTitle = Resources.Strings.step2Title
            self.progress = 1
            self.textFieldOpacity = 0
            self.skipButtonOpacity = 1
            self.datePickerOpacity = 1
        }
    }
    
    func save() {
        guard let usedId = Auth.auth().currentUser?.uid else { return }
        let newList = ShoppingList(name: listTitle, dueDate: dueDate, isDone: false)
        let dataBase = Firestore.firestore()
        dataBase.collection("users")
            .document(usedId)
            .collection("lists")
            .document(newList.id)
            .setData(newList.asDictionary())
        self.listId = newList.id
    }
}
