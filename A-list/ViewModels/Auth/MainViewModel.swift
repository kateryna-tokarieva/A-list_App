//
//  MainViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 25.06.2024.
//

import Combine
import FirebaseAuth

class MainViewModel: ObservableObject {
    @Published var currentUserId = ""
    @Published var isAuthenticated: Bool = false
    @Published var showingHomeSheet: Bool = false
    
    private var authService = FirebaseAuthService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupAuthListener()
    }
    
    private func setupAuthListener() {
        let authStateChanges = NotificationCenter.default.publisher(for: Notification.Name.AuthStateDidChange, object: Auth.auth())
            .map { notification -> FirebaseAuth.User? in
                let auth = notification.object as? Auth
                return auth?.currentUser
            }
            .share()

        authStateChanges
            .map { $0?.uid ?? "" }
            .receive(on: RunLoop.main)
            .assign(to: \.currentUserId, on: self)
            .store(in: &cancellables)

        authStateChanges
            .map { $0 != nil }
            .receive(on: RunLoop.main)
            .sink { [weak self] isAuthenticated in
                self?.isAuthenticated = isAuthenticated
                self?.showingHomeSheet = isAuthenticated 
            }
            .store(in: &cancellables)
    }
}
