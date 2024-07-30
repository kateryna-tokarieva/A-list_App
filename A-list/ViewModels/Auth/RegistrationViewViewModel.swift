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
    
    init(email: String = "", password: String = "", name: String = "") {
        self.email = email
        self.password = password
        self.name = name
    }
    
    func register() {
        email = email.trimmingCharacters(in: .whitespaces)
        password = password.trimmingCharacters(in: .whitespaces)
        name = name.trimmingCharacters(in: .whitespaces)
        
        guard validate() else { return }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let userId = result?.user.uid {
                self?.userId = userId
                self?.insertUserRecord(id: userId)
                self?.registrationSuccessPublisher.send(())
            }
            if let error {
                self?.error = self?.translateError(error) ?? "Невідома помилка"
            }
        }
    }
    
    private func insertUserRecord(id: String) {
        let newUser = User(id: id, name: name, image: "", email: email, settings: Settings())
        let dataBase = Firestore.firestore()
        dataBase.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
    
    private func validate() -> Bool {
        guard isValidEmail(email) else {
            error = "Некоректний формат електронної пошти."
            return false
        }
        
        guard isValidPassword(password) else {
            error = "Пароль повинен містити щонайменше 8 символів, включаючи одну велику літеру, одну малу літеру та одну цифру."
            return false
        }
        
        guard isValidName(name) else {
            error = "Ім'я повинно містити щонайменше 3 символи."
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
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
    
    private func translateError(_ error: Error) -> String {
        let nsError = error as NSError
        switch nsError.code {
        case AuthErrorCode.networkError.rawValue:
            return "Проблеми з підключенням до мережі. Спробуйте ще раз."
        case AuthErrorCode.userNotFound.rawValue:
            return "Користувача не знайдено. Перевірте введені дані."
        case AuthErrorCode.invalidEmail.rawValue:
            return "Неправильний формат електронної пошти."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "Ця електронна пошта вже використовується."
        case AuthErrorCode.weakPassword.rawValue:
            return "Пароль занадто слабкий. Використовуйте щонайменше 8 символів, включаючи одну велику літеру, одну малу літеру та одну цифру."
        default:
            return "Невідома помилка: \(nsError.localizedDescription)"
        }
    }
}
