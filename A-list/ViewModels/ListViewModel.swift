//
//  ListViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 23.06.2024.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class ListViewModel: ObservableObject {
    @Published var list: ShoppingList?
    @Published var stateIsEditing = false
    @Published var buttonImage = Resources.Images.edit
    @Published var newItemTitle = ""
    @Published var newItemQuantity = ""
    @Published var newItemUnit: Unit = .pc
    @Published var itemIcons: [Image] = []
    @Published var doneItemsText = ""
    @Published var scannedCode: String?
    private var doneItemsCount = 0
    private var listId: String
    private var service = BarcodeDataService()
    
    init(listID: String) {
        self.listId = listID
        fetchList()
    }
    
    func addItem(_ item: ShoppingItem) {
        list?.items?.append(item)
        itemIcons.append(Resources.Images.notDone)
        saveItemToDatabase(item)
    }
    
    func deleteItem(withIndex index: Int) {
        guard let itemToDelete = list?.items?[index] else { return }
        deleteItemFromDatabase(itemToDelete)
        fetchList()
    }
    
    func toggleItemIsDone(index: Int) {
        guard var item = list?.items?[index] else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        item.isDone.toggle()
        
        let dataBase = Firestore.firestore()
        let itemDocument = dataBase.collection("users").document(userId).collection("lists").document(listId).collection("items").document(item.id)
        itemDocument.updateData(["isDone": item.isDone]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.list?.items?[index].isDone = item.isDone
                    self?.itemIcons[index] = item.isDone ? Resources.Images.done : Resources.Images.notDone
                    self?.updateDoneItemsText()
                }
            }
        }
    }
    
    func deleteList() {
        guard let list else { return }
        deleteListFromDatabase(list)
    }
    
    func updateForState() {
        buttonImage = stateIsEditing ? Resources.Images.checkmark : Resources.Images.edit
    }
    
    func fetchList() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let dataBase = Firestore.firestore()
        
        let listDocument = dataBase.collection("users").document(userId).collection("lists").document(listId)
        listDocument.getDocument { [weak self] snapshot, error in
            guard let self = self, let data = snapshot?.data() else { return }
            self.list = ShoppingList(id: data["id"] as? String ?? "",
                                     name: data["name"] as? String ?? "",
                                     items: data["items"] as? [ShoppingItem] ?? nil,
                                     dueDate: data["dueDate"] as? Date ?? nil,
                                     isDone: data["isDone"] as? Bool ?? false)
            self.fetchItems()
        }
    }
    
    func fetchCodeData() {
        guard let code = scannedCode, !code.isEmpty else { return }
        service.fetchData(search: code) { [weak self] item in
            guard let self = self else { return }
            addItem(item.asShoppingItem()) 
        }
    }
    
    private func fetchItems() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let dataBase = Firestore.firestore()
        
        let itemsCollection = dataBase.collection("users").document(userId).collection("lists").document(listId).collection("items")
        itemsCollection.getDocuments { [weak self] snapshot, error in
            guard let self = self, let documents = snapshot?.documents else { return }
            self.list?.items = documents.compactMap { document in
                try? document.data(as: ShoppingItem.self)
            }
            self.setupIcons()
            self.updateDoneItemsText()
        }
    }
    
    private func setupIcons() {
        itemIcons = list?.items?.map { $0.isDone ? Resources.Images.done : Resources.Images.notDone } ?? []
    }
    
    private func updateDoneItemsText() {
        doneItemsCount = list?.items?.filter { $0.isDone }.count ?? 0
        doneItemsText = "\(doneItemsCount)/\(list?.items?.count ?? 0)"
    }
    
    private func saveItemToDatabase(_ item: ShoppingItem) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let dataBase = Firestore.firestore()
        
        let itemDocument = dataBase.collection("users").document(userId).collection("lists").document(listId).collection("items").document(item.id)
        itemDocument.setData(item.asDictionary())
    }
    
    private func deleteItemFromDatabase(_ item: ShoppingItem) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let dataBase = Firestore.firestore()
        
        let itemDocument = dataBase.collection("users").document(userId).collection("lists").document(listId).collection("items").document(item.id)
        itemDocument.delete()
    }
    
    private func deleteListFromDatabase(_ list: ShoppingList) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let dataBase = Firestore.firestore()
        
        let listDocument = dataBase.collection("users").document(userId).collection("lists").document(list.id)
        listDocument.delete()
    }
}
