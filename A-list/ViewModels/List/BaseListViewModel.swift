//
//  BaseListViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 09.07.2024.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class BaseListViewModel: ObservableObject {
    @Published var list: ShoppingList?
    @Published var stateIsEditing = false
    @Published var buttonImage = Resources.Images.edit
    @Published var newItemTitle = ""
    @Published var newItemQuantity = ""
    @Published var newItemUnit: Unit = .pc
    @Published var itemIcons: [Image] = []
    @Published var doneItemsText = ""
    @Published var scannedCode: String?
    var listId: String
    let userId = Auth.auth().currentUser?.uid
    let dataBase = Firestore.firestore()
    private var service = BarcodeDataService()
    private var doneItemsCount = 0
    
    init(listId: String) {
        self.listId = listId
    }
    
    //MARK: Updating UI
    
    func updateForState() {
        buttonImage = stateIsEditing ? Resources.Images.checkmark : Resources.Images.edit
    }
    
    func setupIcons() {
        itemIcons = list?.items?.map { $0.isDone ? Resources.Images.done : Resources.Images.notDone } ?? []
    }
    
    func updateDoneItemsText() {
        doneItemsCount = list?.items?.filter { $0.isDone }.count ?? 0
        doneItemsText = "\(doneItemsCount)/\(list?.items?.count ?? 0)"
    }
    
    //MARK: Items
    
    func fetchItems(ownerId: String) {
        let itemsCollection = dataBase.collection("users").document(ownerId).collection("lists").document(listId).collection("items")
        itemsCollection.getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching items: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }
            
            DispatchQueue.main.async {
                self.list?.items = documents.compactMap { document in
                    do {
                        return try document.data(as: ShoppingItem.self)
                    } catch {
                        print("Error decoding document into ShoppingItem: \(error)")
                        return nil
                    }
                }
                self.setupIcons()
                self.updateDoneItemsText()
            }
        }
    }
    
    func addItem(_ item: ShoppingItem, ownerId: String) {
        list?.items?.append(item)
        itemIcons.append(Resources.Images.notDone)
        saveItemToDatabase(item, ownerId: ownerId)
        setupIcons()
        updateDoneItemsText()
    }
    
    private func saveItemToDatabase(_ item: ShoppingItem, ownerId: String) {
        let itemDocument = dataBase.collection("users").document(ownerId).collection("lists").document(listId).collection("items").document(item.id)
        itemDocument.setData(item.asDictionary())
    }
    
    func fetchCodeData(ownerId: String) {
        guard let code = scannedCode, !code.isEmpty else { return }
        service.fetchData(search: code) { [weak self] item in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.addItem(item.asShoppingItem(), ownerId: ownerId)
            }
        }
    }
    
    func editItem(withIndex index: Int) {
        stateIsEditing = true
        guard let itemToEdit = list?.items?[index] else { return }
        newItemTitle = itemToEdit.title
        newItemQuantity = itemToEdit.quantity
        newItemUnit = itemToEdit.unit
    }
    
    func toggleItemIsDone(index: Int, ownerId: String) {
        guard var item = list?.items?[index] else { return }
        
        item.isDone.toggle()
        
        let itemDocument = dataBase.collection("users").document(ownerId).collection("lists").document(listId).collection("items").document(item.id)
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
    
    func deleteItem(withIndex index: Int, ownerId: String) {
        guard let itemToDelete = list?.items?[index] else { return }
        let itemDocument = dataBase.collection("users").document(ownerId).collection("lists").document(listId).collection("items").document(itemToDelete.id)
        itemDocument.delete()
    }
    
    //MARK: List
    
    func fetchList(ownerId: String) {
        let listDocument = dataBase.collection("users").document(ownerId).collection("lists").document(listId)
        listDocument.getDocument { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching list: \(error)")
                return
            }
            guard let self = self, let data = snapshot?.data() else {
                return
            }
            self.list = ShoppingList(id: data["id"] as? String ?? "",
                                     name: data["name"] as? String ?? "",
                                     items: data["items"] as? [ShoppingItem] ?? nil,
                                     dueDate: (data["dueDate"] as? Timestamp)?.dateValue(),
                                     isDone: data["isDone"] as? Bool ?? false,
                                     sharedWithFriends: data["friends"] as? [String] ?? [],
                                     owner: data["owner"] as? String ?? nil)
        }
    }
    
    func deleteList() {
        guard let list, let userId else { return }
        let listDocument = dataBase.collection("users").document(userId).collection("lists").document(list.id)
        listDocument.delete()
    }
}
