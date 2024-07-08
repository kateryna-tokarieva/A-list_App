//
//  RegistrationViewViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 26.06.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class RegistrationViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var error: String = ""
    @Published var userId: String = ""
    @Published var showingLoginSheet = false
    
    init(email: String = "", password: String = "", name: String = "") {
        self.email = email
        self.password = password
        self.name = name
    }
    
    func register() {
        guard validate() else { return }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let userId = result?.user.uid {
                self?.userId = userId
                self?.insertUserRecord(id: userId)
                self?.showingLoginSheet.toggle()
            }
            if let error {
                self?.error = error.localizedDescription
            }
        }
    }
    
    func insertUserRecord(id: String) {
        let newUser = User(id: id, name: name, image: "", email: email, friends: [], settings: Settings())
        let dataBase = Firestore.firestore()
        dataBase.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
        
    private func validate() -> Bool {
         true
    }
}
