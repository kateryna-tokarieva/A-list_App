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
    @Published var itemFulfillmentIcon = Resources.Images.notDone
    @Published var newItemTitle = ""
    @Published var newItemQuantity = ""
    @Published var newItemUnit: Unit = .pc
    @Published var itemIcons: [Image] = []
    @Published var listId = ""
    
    init(listID: String) {
        self.listId = listID
        fetchList()
    }
    
    func addItem(_ item: ShoppingItem) {
        list?.items?.append(item)
        itemIcons.append(Resources.Images.notDone)
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let list else { return }
        let dataBase = Firestore.firestore()
        dataBase.collection("users")
            .document(userId)
            .collection("lists")
            .document(list.id)
            .collection("items")
            .document(item.id)
            .setData(item.asDictionary())
    }
    
    func deleteItem(withIndex index: Int) {
        let itemToDelete = list?.items?.remove(at: index)
        itemIcons.remove(at: index)
        guard let id = itemToDelete?.id else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let list else { return }
        let dataBase = Firestore.firestore()
        dataBase.collection("users")
            .document(userId)
            .collection("lists")
            .document(list.id)
            .collection("items")
            .document(id)
            .delete()
    }
    
    func fetchList() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let dataBase = Firestore.firestore()
        dataBase.collection("users").document(userId).collection("lists").document(listId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data() else { return }
            DispatchQueue.main.async {
                self?.list = ShoppingList(id: data["id"] as? String ?? "",
                                          name: data["name"] as? String ?? "",
                                          items: data["items"] as? [ShoppingItem] ?? nil,
                                          dueDate: data["dueDate"] as? Date ?? nil,
                                          isDone: data["isDone"] as? Bool ?? false)
                
            }
            guard let self else { return }
            dataBase.collection("users").document(userId).collection("lists").document(self.listId).collection("items").getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                } else {
                    guard let documents = snapshot?.documents else { return }
                    self.list?.items = documents.compactMap { document in
                        do {
                            return try document.data(as: ShoppingItem.self)
                        } catch {
                            print("Error decoding document into ShoppingList: \(error)")
                            return nil
                        }
                    }
                    self.setupIcons()
                }
            }
        }
    }
    
    private func setupIcons() {
        guard let items = list?.items else { return }
        for item in items {
            if item.isDone {
                itemIcons.append(Resources.Images.done)
            } else {
                itemIcons.append(Resources.Images.notDone)
            }
        }
    }
    
    func updateForState() {
        switch stateIsEditing {
        case true:
            buttonImage = Resources.Images.checkmark
        case false:
            buttonImage = Resources.Images.edit
        }
    }
    
    func toggleItemIsDone(index: Int) {
        toggleItemIsDoneInDataBase(index: index)
        if itemIcons[index] == Resources.Images.notDone {
            itemIcons[index] = Resources.Images.done
        } else {
            itemIcons[index] = Resources.Images.notDone
        }
    }
    
    private func toggleItemIsDoneInDataBase(index: Int) {
        list?.items?[index].isDone.toggle()
        guard let item = list?.items else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let dataBase = Firestore.firestore()
        dataBase.collection("users").document(userId).collection("lists").document(listId).collection("items").document("\(String(describing: list?.items?[index].id))").setData(item[index].asDictionary())
    }
}

