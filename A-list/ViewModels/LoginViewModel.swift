//
//  LoginViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 24.06.2024.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error: String = ""
    @Published var userId: String = ""
    @Published var showingHomeSheet = false
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    func login() {
        guard validate() else { return }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let userId = result?.user.uid {
                self?.userId = userId
                self?.showingHomeSheet.toggle()
            }
            if let error {
                self?.error = error.localizedDescription
            }
            
        }
    }
        
    private func validate() -> Bool {
         true
    }
}
