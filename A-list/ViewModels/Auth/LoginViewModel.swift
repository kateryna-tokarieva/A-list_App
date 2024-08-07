//
//  LoginViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 24.06.2024.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error: String = ""
    @Published var userId: String = ""
    @Published var showingHomeSheet = false
    
    init(email: String = "", password: String = "") {
        self.email = email
        self.password = password
    }
    
    func login() {
        email = email.trimmingCharacters(in: .whitespaces)
        password = password.trimmingCharacters(in: .whitespaces)
        
        guard validate() else { return }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let userId = result?.user.uid {
                self?.userId = userId
                self?.showingHomeSheet.toggle()
            }
            if let error {
                self?.error = self?.translateError(error) ?? "Невідома помилка"
            }
        }
    }
    
    private func validate() -> Bool {
        guard isValidEmail(email) else {
            error = "Некоректний формат електронної пошти."
            return false
        }
        
        guard !password.isEmpty else {
            error = "Пароль не може бути порожнім."
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
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
        case AuthErrorCode.wrongPassword.rawValue:
            return "Неправильний пароль. Спробуйте ще раз."
        default:
            return "Невідома помилка: \(nsError.localizedDescription)"
        }
    }

}
