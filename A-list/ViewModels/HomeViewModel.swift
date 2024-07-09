//
//  HomeViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 24.06.2024.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class HomeViewModel: ObservableObject {
    @Published var lists: [ShoppingList] = []
    @Published var sharedLists: [ShoppingList] = []
    @Published var currentListId = ""
    
    init() {
        Task {
            await fetchLists()
            await fetchSharedLists()
        }
    }
    
    @MainActor
    func fetchLists() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user ID found")
            return
        }
        let dataBase = Firestore.firestore()
        
        do {
            let snapshot = try await dataBase.collection("users").document(userId).collection("lists").getDocuments()
            
            let documents = snapshot.documents
            guard !documents.isEmpty else {
                print("No documents found in user's lists collection")
                return
            }
            
            let listIds = documents.compactMap { document in
                return document["id"] as? String
            }
            
            var lists: [ShoppingList] = []
            
            for id in listIds {
                if let list = await fetchList(listId: id) {
                    lists.append(list)
                }
            }
            
            self.lists = lists
        } catch {
            print("Error fetching documents: \(error)")
        }
    }
    
    @MainActor
    func fetchList(listId: String) async -> ShoppingList? {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user ID found in fetchList")
            return nil
        }
        let dataBase = Firestore.firestore()
        
        do {
            let document = try await dataBase.collection("users").document(userId).collection("lists").document(listId).getDocument()
            guard let data = document.data() else {
                print("No data found for document with ID: \(listId)")
                return nil
            }
            
            var list = ShoppingList(
                id: data["id"] as? String ?? "",
                name: data["name"] as? String ?? "",
                items: [],
                dueDate: (data["dueDate"] as? Timestamp)?.dateValue(),
                isDone: data["isDone"] as? Bool ?? false
            )
            
            let itemsSnapshot = try await dataBase.collection("users").document(userId).collection("lists").document(listId).collection("items").getDocuments()
            
            list.items = itemsSnapshot.documents.compactMap { document in
                do {
                    return try document.data(as: ShoppingItem.self)
                } catch {
                    print("Error decoding document into ShoppingItem: \(error)")
                    return nil
                }
            }
            return list
        } catch {
            print("Error fetching document: \(error)")
            return nil
        }
    }
    
    @MainActor
    func fetchSharedLists() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user ID found")
            return
        }
        let dataBase = Firestore.firestore()
        do {
            let snapshot = try await dataBase.collection("users").document(userId).collection("sharedLists").getDocuments()
            
            let documents = snapshot.documents
            guard !documents.isEmpty else {
                print("No documents found in user's shared lists collection")
                return
            }
            
            let sharedLists: [SharedList] = documents.compactMap { document in
                guard
                    let id = document["id"] as? String,
                    let ownerId = document["ownerId"] as? String
                else {
                    print("Document missing id or ownerId: \(document.data())")
                    return nil
                }
                return SharedList(id: id, ownerId: ownerId)
            }
            
            var lists: [ShoppingList] = []
            
            for list in sharedLists {
                if let shoppingList = await fetchSharedList(listId: list.id, ownerId: list.ownerId) {
                    lists.append(shoppingList)
                }
            }
            
            self.sharedLists = lists
            print("Successfully fetched shared lists: \(self.sharedLists)")
        } catch {
            print("Error fetching documents: \(error)")
        }
    }

    
    @MainActor
    func fetchSharedList(listId: String, ownerId: String) async -> ShoppingList? {
        let dataBase = Firestore.firestore()
        
        do {
            let document = try await dataBase.collection("users").document(ownerId).collection("lists").document(listId).getDocument()
            guard let data = document.data() else {
                print("No data found for document with ID: \(listId)")
                return nil
            }
            
            var list = ShoppingList(
                id: data["id"] as? String ?? "",
                name: data["name"] as? String ?? "",
                items: [],
                dueDate: (data["dueDate"] as? Timestamp)?.dateValue(),
                isDone: data["isDone"] as? Bool ?? false
            )
            
            let itemsSnapshot = try await dataBase.collection("users").document(ownerId).collection("lists").document(listId).collection("items").getDocuments()
            
            list.items = itemsSnapshot.documents.compactMap { document in
                do {
                    return try document.data(as: ShoppingItem.self)
                } catch {
                    print("Error decoding document into ShoppingItem: \(error)")
                    return nil
                }
            }
            return list
        } catch {
            print("Error fetching document: \(error)")
            return nil
        }
    }
}
