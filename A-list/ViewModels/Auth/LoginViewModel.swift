//
//  LoginViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 24.06.2024.
//

import Foundation
import FirebaseAuth
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error: String = ""
    @Published var userId: String = ""
    @Published var showingHomeSheet = false
    
    private let authService: AuthService
    private var cancellables = Set<AnyCancellable>()
    
    init(email: String = "", password: String = "", authService: AuthService = FirebaseAuthService.shared) {
        self.email = email
        self.password = password
        self.authService = authService
    }
    
    func login() {
        email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard validateInputs() else { return }
        
        authService.signIn(withEmail: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = self?.authService.translateError(error) ?? "Невідома помилка"
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                self?.userId = result.user.uid
                self?.showingHomeSheet = true
            })
            .store(in: &cancellables)
    }
    
    private func validateInputs() -> Bool {
        guard isValidEmail(email) else {
            error = "Неправильний формат електронної пошти."
            return false
        }
        
        guard !password.isEmpty else {
            error = "Пароль не може бути пустим."
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
