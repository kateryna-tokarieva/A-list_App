//
//  HomeViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 24.06.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class HomeViewModel: ObservableObject {
    //@Published var currentCategory = "Всі списки"
    @Published var userId: String = ""
    //@Published var user: User?
    //@Published var lists: [ShoppingList]?
    
    
    
//    func fetchUser() {
//        guard let userId = Auth.auth().currentUser?.uid else { return }
//        let dataBase = Firestore.firestore()
//        dataBase.collection("users").document(userId).getDocument { [weak self] snapshot, error in
//            guard let data = snapshot?.data() else { return }
//            DispatchQueue.main.async {
//                self?.user = User(
//                    id: data["id"] as? String ?? "",
//                    name: data["name"] as? String ?? "",
//                    email: data["email"] as? String ?? "",
//                    settings: data["settings"] as? Settings ?? Settings())
//            }
//        }
//    }
    
    func fetchLists() -> [ShoppingList] {
        let userId = Auth.auth().currentUser?.uid
        @FirestoreQuery var lists: [ShoppingList]
        _lists = FirestoreQuery(collectionPath: "users/\(String(describing: userId))/lists")
        print(lists)
        return lists
        
    }
}
