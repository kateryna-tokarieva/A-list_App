//
//  UserSettingsViewViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 10.07.2024.
//

import Foundation
import FirebaseAuth

class UserSettingsViewViewModel: ObservableObject {
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            
        }
    }
}
