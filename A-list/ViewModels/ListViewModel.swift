//
//  ListViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 23.06.2024.
//

import Foundation
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
    
    init(listID: String) {
        fetchList(listId: listID)
    }
    
    func addItem(_ item: ShoppingItem) {
        list?.items?.append(item)
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
    
    func deleteItem(withIndex index: String) {
        guard let intIndex = Int(index) else { return }
        let itemToDelete = list?.items?.remove(at: intIndex)
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
    
    func fetchList(listId: String) {
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
            dataBase.collection("users").document(userId).collection("lists").document(listId).collection("items").getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                } else {
                    guard let documents = snapshot?.documents else { return }
                    self?.list?.items = documents.compactMap { document in
                        do {
                            return try document.data(as: ShoppingItem.self)
                        } catch {
                            print("Error decoding document into ShoppingList: \(error)")
                            return nil
                        }
                    }
                }
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
    
    func toggleItemIsDone() {
        if itemFulfillmentIcon == Resources.Images.notDone {
            itemFulfillmentIcon = Resources.Images.done
        } else {
            itemFulfillmentIcon = Resources.Images.notDone
        }
    }
}

