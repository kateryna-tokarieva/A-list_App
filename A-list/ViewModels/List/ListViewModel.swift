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

class ListViewModel: BaseListViewModel {
    @Published var sharedFriends: [User] = []
    private var friendsIds: [String] = []
    var friends: [User] = []
    
    override init(listId: String) {
        super.init(listId: listId)
        fetchList()
    }
    
    //MARK: List
    
    func fetchList() {
        guard let userId else { return }
        fetchList(ownerId: userId)
        fetchItems(ownerId: userId)
        Task {
            await fetchFriends()
            await fetchSharedFriends()
        }
    }
    
    //MARK: Items
    
    func addItem(_ item: ShoppingItem) {
        guard let userId else { return }
        addItem(item, ownerId: userId)
    }
    
    func deleteItem(withIndex index: Int) {
        guard let userId else { return }
        deleteItem(withIndex: index, ownerId: userId)
    }
    
    func toggleItemIsDone(index: Int) {
        guard let userId else { return }
        toggleItemIsDone(index: index, ownerId: userId)
    }
    
    override func editItem(withIndex index: Int) {
        guard let userId else { return }
        super.editItem(withIndex: index)
        deleteItem(withIndex: index, ownerId: userId)
        fetchItems(ownerId: userId)
    }
    
    func fetchCodeData() {
        guard let userId else { return }
        fetchCodeData(ownerId: userId)
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
        
        guard let list, let sharedWithFriends = list.sharedWithFriends else {
            print("No friends to fetch or sharedWithFriends is empty")
            return
        }
        
        var users: [User] = []
        
        for id in sharedWithFriends {
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
        let sharedList = SharedList(id: list.id, ownerId: userId)
        dataBase.collection("users")
            .document(id)
            .collection("sharedLists")
            .document(sharedList.id).setData(sharedList.asDictionary())
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
        let friendsList = dataBase.collection("users").document(id).collection("sharedLists").document(listId)
        friendsList.delete { error in
            if let error = error {
                print("Error deleting friend: \(error)")
                return
            }
        }
    }
}
