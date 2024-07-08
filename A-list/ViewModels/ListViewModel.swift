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
    @Published var sharedFriends: [User] = []
    private var friendsIds: [String] = []
    var friends: [User] = []
    private var doneItemsCount = 0
    private var listId: String
    private var service = BarcodeDataService()
    private let dataBase = Firestore.firestore()
    
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
    
    //MARK: Items
    
    private func fetchItems() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
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
    
    func addItem(_ item: ShoppingItem) {
        list?.items?.append(item)
        itemIcons.append(Resources.Images.notDone)
        saveItemToDatabase(item)
        setupIcons()
        updateDoneItemsText()
    }
    
    func deleteItem(withIndex index: Int) {
        guard let itemToDelete = list?.items?[index] else { return }
        deleteItemFromDatabase(itemToDelete)
        
           fetchList()
       
    }
    
    private func saveItemToDatabase(_ item: ShoppingItem) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let itemDocument = dataBase.collection("users").document(userId).collection("lists").document(listId).collection("items").document(item.id)
        itemDocument.setData(item.asDictionary())
    }
    
    private func deleteItemFromDatabase(_ item: ShoppingItem) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let itemDocument = dataBase.collection("users").document(userId).collection("lists").document(listId).collection("items").document(item.id)
        itemDocument.delete()
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
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        item.isDone.toggle()
        
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
    
    func fetchCodeData() {
        guard let code = scannedCode, !code.isEmpty else { return }
        service.fetchData(search: code) { [weak self] item in
            guard let self = self else { return }
            addItem(item.asShoppingItem())
        }
    }
    
    //MARK: List
    
    func fetchList() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let listDocument = dataBase.collection("users").document(userId).collection("lists").document(listId)
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
            Task {
                await self.fetchFriends()
                await self.fetchSharedFriends()
            }
        }
    }
    
    func deleteList() {
        guard let list else { return }
        deleteListFromDatabase(list)
    }
    
    private func deleteListFromDatabase(_ list: ShoppingList) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let listDocument = dataBase.collection("users").document(userId).collection("lists").document(list.id)
        listDocument.delete()
    }
    
    //MARK: Friends
    
    func fetchFriends() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            let snapshot = try await dataBase.collection("users").document(userId).collection("friends").getDocuments()
            let documents = snapshot.documents
            
            guard !documents.isEmpty else {
                print("No documents found in user's friends collection")
                return
            }
            
            let friendsIds = documents.compactMap { document in
                document["id"] as? String
            }
            self.friendsIds = friendsIds
            await fetchUsersByIds(ids: friendsIds)
            
        } catch {
            print("Error fetching documents: \(error)")
            
        }
    }
    
    private func fetchUsersByIds(ids: [String]) async {
        var users: [User] = []
        
        for id in ids {
            do {
                let document = try await dataBase.collection("users").document(id).getDocument()
                
                if document.exists, let user = try? document.data(as: User.self) {
                    users.append(user)
                } else {
                    print("Document does not exist or failed to decode for user with ID: \(id)")
                }
            } catch {
                print("Error fetching user with ID \(id): \(error.localizedDescription)")
            }
        }
        
        self.friends = users
    }
    
    @MainActor
    private func fetchSharedFriends() async {
        guard let listId = list?.id, let userId = Auth.auth().currentUser?.uid else {
            print("List ID or User ID is nil")
            return
        }
        
        let friendsCollection = dataBase.collection("users").document(userId).collection("lists").document(listId).collection("friends")
        
        do {
            let snapshot = try await friendsCollection.getDocuments()
            self.list?.sharedWithFriends = snapshot.documents.compactMap { document in
                document["id"] as? String
            }
        } catch {
            print("Error fetching friends collection: \(error.localizedDescription)")
            return
        }
        
        guard let list = list, !list.sharedWithFriends.isEmpty else {
            print("No friends to fetch or sharedWithFriends is empty")
            return
        }

        var users: [User] = []
        
        for id in list.sharedWithFriends {
            do {
                let document = try await dataBase.collection("users").document(id).getDocument()
                
                if document.exists, let user = try? document.data(as: User.self) {
                    users.append(user)
                } else {
                    print("Document does not exist or failed to decode for user with ID: \(id)")
                }
            } catch {
                print("Error fetching user with ID \(id): \(error.localizedDescription)")
            }
        }
        
        self.sharedFriends = users
    }



    
    func shareWithFriend(withName name: String) {
        var friendId = ""
        for friend in friends {
            if friend.name == name {
                friendId = friend.id
            }
        }
        if !friendId.isEmpty {
            shareWithFriend(withId: friendId)
        }
    }
    
    private func shareWithFriend(withId id: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        dataBase.collection("users").document(userId).collection("lists").document(listId).collection("friends").document(id).setData(["id":id])
        fetchList()
        addListToFriend(withId: id)
    }
    
    private func addListToFriend(withId id: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let list else { return }
        var newList = list
        newList.owner = userId
        dataBase.collection("users")
            .document(id)
            .collection("lists")
            .document(newList.id).setData(newList.asDictionary())
    }
    
    func deleteFriendFromShared(withName name: String) {
        var friendId = ""
        for friend in friends {
            if friend.name == name {
                friendId = friend.id
            }
        }
        if !friendId.isEmpty {
            deleteFriendFromShared(withId: friendId)
        }
    }
    
    private func deleteFriendFromShared(withId id: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        dataBase.collection("users").document(userId).collection("lists").document(listId).collection("friends").document(id).delete {error in
            if let error = error {
                print("Error deleting friend: \(error)")
                return
            }
        }
        
        guard let list else { return }
        fetchList()
        deleteListFromFriend(withId: id, listId: list.id)
    }
    
    private func deleteListFromFriend(withId id: String, listId: String)  {
        let friendsList = dataBase.collection("users").document(id).collection("lists").document(listId)
        friendsList.delete { error in
            if let error = error {
                print("Error deleting friend: \(error)")
                return
            }
        }
    }
}
