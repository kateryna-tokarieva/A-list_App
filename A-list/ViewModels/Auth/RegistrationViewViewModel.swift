//
//  RegistrationViewViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 26.06.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

class RegistrationViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var error: String = ""
    @Published var userId: String = ""
    var registrationSuccessPublisher = PassthroughSubject<Void, Never>()
    
    private let authService: AuthService
    private var cancellables = Set<AnyCancellable>()
    
    init(email: String = "", password: String = "", name: String = "", authService: AuthService = FirebaseAuthService.shared) {
        self.email = email
        self.password = password
        self.name = name
        self.authService = authService
    }
    
    func register() {
        email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard validate() else { return }
        
        authService.signUp(email: email, password: password, name: name)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = self?.authService.translateError(error) ?? "Unknown error"
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                self?.userId = result.user.uid
                self?.insertUserRecord(id: result.user.uid)
                self?.registrationSuccessPublisher.send(())
            })
            .store(in: &cancellables)
    }
    
    private func insertUserRecord(id: String) {
        let newUser = User(id: id, name: name, image: "", email: email, settings: Settings())
        let dataBase = Firestore.firestore()
        dataBase.collection("users")
            .document(id)
            .setData(newUser.asDictionary()) { [weak self] error in
                if let error = error {
                    self?.error = "Failed to save user data: \(error.localizedDescription)"
                }
            }
    }
    
    private func validate() -> Bool {
        guard isValidEmail(email) else {
            error = "Invalid email format."
            return false
        }
        
        guard isValidPassword(password) else {
            error = "Password must be at least 8 characters long, with one uppercase letter, one lowercase letter, and one number."
            return false
        }
        
        guard isValidName(name) else {
            error = "Name must be at least 3 characters long."
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d$@$!%*?&]{8,}"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    private func isValidName(_ name: String) -> Bool {
        return name.count >= 3
    }
}
