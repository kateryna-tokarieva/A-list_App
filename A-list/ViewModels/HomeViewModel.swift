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
    
    init(userId: String) {
        fetchLists(userId: userId)
    }
    
    func fetchLists(userId: String) {
        let dataBase = Firestore.firestore()
        dataBase.collection("users").document(userId).collection("lists").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                guard let documents = snapshot?.documents else { return }
                self.lists = documents.compactMap { document in
                    do {
                        return try document.data(as: ShoppingList.self)
                    } catch {
                        print("Error decoding document into ShoppingList: \(error)")
                        return nil
                    }
                }                
            }
        }
    }
}
