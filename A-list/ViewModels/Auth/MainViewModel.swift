//
//  MainViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import Foundation
import FirebaseAuth
import Combine

class MainViewModel: ObservableObject {
    @Published var currentUserId = ""
    private var handler: AuthStateDidChangeListenerHandle?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
            }
        }
    }
    
    deinit {
        if let handler = handler {
            Auth.auth().removeStateDidChangeListener(handler)
        }
    }
    
    public var isSignedIn: Bool {
        Auth.auth().currentUser != nil
    }
}

