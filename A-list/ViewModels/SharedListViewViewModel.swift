//
//  SharedListViewViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 08.07.2024.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class SharedListViewViewModel: ObservableObject {
    @Published var stateIsEditing = false
    @Published var buttonImage = Resources.Images.edit
    @Published var scannedCode: String?
    @Published var itemIcons: [Image] = []
    @Published var list: ShoppingList?
    @Published var newItemTitle = ""
    @Published var newItemQuantity = ""
    @Published var newItemUnit: Unit = .pc
    @Published var doneItemsText = ""
    private let dataBase = Firestore.firestore()
    private var doneItemsCount = 0
    private var sharedList: SharedList?
    private var listId: String
    private var service = BarcodeDataService()
    
    init(listID: String) {
        self.listId = listID
        fetchList()
    }
    
    //MARK: Updating UI
    
    func updateForState() {
        buttonImage = stateIsEditing ? Resources.Images.checkmark : Resources.Images.edit
    }
    
    private func setupIcons() {
        itemIcons = list?.items?.map { $0.isDone ? Resources.Images.done : Resources.Images.notDone } ?? []
    }
    
    private func updateDoneItemsText() {
        doneItemsCount = list?.items?.filter { $0.isDone }.count ?? 0
        doneItemsText = "\(doneItemsCount)/\(list?.items?.count ?? 0)"
    }
    
    func fetchSharedList() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let sharedListDocument = dataBase.collection("sharedLists").document(listId)
        sharedListDocument.getDocument { [weak self] snapshot, error in
            guard let self = self, let data = snapshot?.data() else { return }
            self.sharedList = SharedList(id: data["id"] as? String ?? "",
                                         ownerId: data["ownerId"] as? String ?? "")
            
            self.fetchList()
        }
    }
    
    func fetchList() {
        guard let sharedList else { return }
        let listDocument = dataBase.collection("users").document(sharedList.ownerId).collection("lists").document(sharedList.id)
        listDocument.getDocument { [weak self] snapshot, error in
            guard let self = self, let data = snapshot?.data() else { return }
            self.list = ShoppingList(id: data["id"] as? String ?? "",
                                     name: data["name"] as? String ?? "",
                                     items: data["items"] as? [ShoppingItem] ?? nil,
                                     dueDate: data["dueDate"] as? Date ?? nil,
                                     isDone: data["isDone"] as? Bool ?? false,
                                     sharedWithFriends: data["friends"] as? [String] ?? [],
                                     owner: data["owner"] as? String ?? nil)
            
            self.fetchItems()
        }
    }
    
    func deleteList() {
        guard let sharedList else { return }
        let sharedListDocument = dataBase.collection("users").document(sharedList.ownerId).collection("lists").document(sharedList.id)
        sharedListDocument.delete()
    }
    
    func fetchItems() {
        guard let sharedList else { return }
        guard let list else { return }
        let itemsCollection = dataBase.collection("users").document(sharedList.ownerId).collection("lists").document(sharedList.id).collection("items")
        itemsCollection.getDocuments { [weak self] snapshot, error in
            guard let self = self, let documents = snapshot?.documents else { return }
            self.list?.items = documents.compactMap { document in
                try? document.data(as: ShoppingItem.self)
            }
            self.setupIcons()
            self.updateDoneItemsText()
        }
    }
    
    func addItem(_ item: ShoppingItem) {
        list?.items?.append(item)
        itemIcons.append(Resources.Images.notDone)
        saveItemToDatabase(item)
        setupIcons()
        updateDoneItemsText()
    }
    
    private func saveItemToDatabase(_ item: ShoppingItem) {
        guard let sharedList else { return }
        let itemDocument = dataBase.collection("users").document(sharedList.ownerId).collection("lists").document(sharedList.id).collection("items").document(item.id)
        itemDocument.setData(item.asDictionary())
    }
    
    func fetchCodeData() {
        guard let code = scannedCode, !code.isEmpty else { return }
        service.fetchData(search: code) { [weak self] item in
            guard let self = self else { return }
            addItem(item.asShoppingItem())
        }
    }
    
    func editItem(withIndex index: Int) {
        stateIsEditing = true
        guard let itemToEdit = list?.items?[index] else { return }
        newItemTitle = itemToEdit.title
        newItemQuantity = itemToEdit.quantity
        newItemUnit = itemToEdit.unit
        deleteItem(withIndex: index)
    }
    
    func toggleItemIsDone(index: Int) {
        guard var item = list?.items?[index] else { return }
        guard let sharedList else { return }

        item.isDone.toggle()
        
        let itemDocument = dataBase.collection("users").document(sharedList.ownerId).collection("lists").document(sharedList.id).collection("items").document(item.id)
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
    
    func deleteItem(withIndex index: Int) {
        guard let sharedList else { return }
        guard let itemToDelete = list?.items?[index] else { return }
        let itemDocument = dataBase.collection("users").document(sharedList.ownerId).collection("lists").document(sharedList.id).collection("items").document(itemToDelete.id)
        itemDocument.delete()
    }
}
