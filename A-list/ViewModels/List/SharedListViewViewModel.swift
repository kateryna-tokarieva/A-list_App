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

class SharedListViewViewModel: BaseListViewModel {
    var sharedList: SharedList?
    
    override init(listId: String) {
        super.init(listId: listId)
        fetchSharedList()
    }
    
    //MARK: List
    
    func fetchSharedList() {
        guard let userId else {
            return
        }
        let sharedListDocument = dataBase.collection("users").document(userId).collection("sharedLists").document(listId)
        sharedListDocument.getDocument { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching shared list: \(error)")
                return
            }
            guard let self = self, let data = snapshot?.data() else {
                print("Shared list not found")
                return
            }
            print("Shared list data: \(data)")
            self.sharedList = SharedList(id: data["id"] as? String ?? "",
                                         ownerId: data["ownerId"] as? String ?? "")
            
            self.fetchList()
        }
    }
    
    func fetchList() {
        guard let sharedList else {
            return
        }
        fetchList(ownerId: sharedList.ownerId)
        fetchItems(ownerId: sharedList.ownerId)
        
    }
    
    override func deleteList() {
        guard let sharedList, let userId else {
            return
        }
        let sharedListDocument = dataBase.collection("users").document(userId).collection("sharedLists").document(sharedList.id)
        sharedListDocument.delete()
    }
    
    //MARK: Items
    
    func addItem(_ item: ShoppingItem) {
        guard let sharedList else { return }
        addItem(item, ownerId: sharedList.ownerId)
    }
    
    func deleteItem(withIndex index: Int) {
        guard let sharedList else { return }
        deleteItem(withIndex: index, ownerId: sharedList.ownerId)
    }
    
    func toggleItemIsDone(index: Int) {
        guard let sharedList else { return }
        toggleItemIsDone(index: index, ownerId: sharedList.ownerId)
    }
    
    override func editItem(withIndex index: Int) {
        guard let sharedList else { return }
        super.editItem(withIndex: index)
        deleteItem(withIndex: index, ownerId: sharedList.ownerId)
        fetchItems(ownerId: sharedList.ownerId)
    }
    
    func fetchCodeData() {
        guard let sharedList else { return }
        fetchCodeData(ownerId: sharedList.ownerId)
    }
}
