//
//  MainViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import Foundation
import FirebaseAuth

class MainViewModel: ObservableObject {
    @Published var currentUserId = ""
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self]  _, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
                
            }
        }
    }
    
    public var isSignedIn: Bool {
        Auth.auth().currentUser != nil
        
    }
}
